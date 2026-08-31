// Christmas Star Tree-Topper Box
// Three printable parts:
//   part = "front"    -> front half-shell (star shaped, prints face down)
//   part = "back"     -> back half-shell with snap lip (prints face down)
//   part = "base"     -> conic base that slides over the tree tip and
//                        locks the two halves at the bottom star point
//   part = "assembly" -> preview of all parts assembled
//
// Render STLs with:
//   openscad -o front.stl -D part=\"front\" star_box.scad
//
// All dimensions in millimeters.

part = "assembly";

/* ---------- Star parameters ---------- */
star_points   = 5;
R             = 75;            // outer radius (tip to center) -> 150 mm tip-to-tip
r             = R * 0.382;     // inner radius of the pentagram
thickness     = 40;            // total box depth (front + back)
wall          = 2;             // wall / face thickness
clearance     = 0.25;          // printing clearance for fits

/* ---------- Snap-fit parameters ---------- */
lip_h         = 8;             // how far the back lip slides into the front
lip_w         = 1.6;           // lip wall width
bump          = 0.5;           // snap ridge interference
ridge_h       = 1.2;           // snap ridge band height
groove_h      = 1.8;           // groove band height (slightly taller)

/* ---------- Conic base parameters ---------- */
cone_h        = 60;            // cone height
cone_r_bottom = 30;            // outer radius at the wide (bottom) end
cone_r_top    = 24;            // outer radius at the top end
cone_wall     = 3;             // minimum cone wall
socket_depth  = 22;            // how deep the star bottom tip sinks into the cone
tree_hole_r   = 13;            // tree tip hole radius at the bottom
tree_hole_top = 5;             // tree tip hole radius at the top of the hole
tree_hole_h   = 34;            // tree tip hole depth (from the bottom)

$fn = 96;
half = thickness / 2;

/* ---------- 2D star ---------- */
module star2d() {
    // one point straight down (-Y), so the bottom tip meets the cone
    polygon([for (i = [0 : 2 * star_points - 1])
        let (a = -90 + i * 180 / star_points,
             rad = (i % 2 == 0) ? R : r)
        [rad * cos(a), rad * sin(a)]]);
}

module star_offset(d) { offset(delta = d) star2d(); }

/* ---------- Front half-shell ----------
   Prints as modeled: outer face on the bed (z = 0), cavity opening up. */
module front() {
    difference() {
        linear_extrude(half) star2d();
        // cavity
        translate([0, 0, wall])
            linear_extrude(half) star_offset(-wall);
        // snap groove in the inner wall, where the back lip's ridge lands
        translate([0, 0, half - lip_h + 0.6])
            linear_extrude(groove_h) difference() {
                star_offset(-wall + bump - 0.1);
                star_offset(-wall - clearance);
            }
    }
}

/* ---------- Back half-shell ----------
   Same shell as the front plus an inner lip with a snap ridge. */
module back() {
    // shell
    difference() {
        linear_extrude(half) star2d();
        translate([0, 0, wall])
            linear_extrude(half) star_offset(-wall);
    }
    // lip that slides inside the front cavity, rising from the floor
    translate([0, 0, wall])
        linear_extrude(half - wall + lip_h) difference() {
            star_offset(-wall - clearance);
            star_offset(-wall - clearance - lip_w);
        }
    // snap ridge near the lip tip
    translate([0, 0, half + lip_h - 0.6 - ridge_h])
        linear_extrude(ridge_h) difference() {
            star_offset(-wall - clearance + bump);
            star_offset(-wall - clearance - lip_w);
        }
}

/* ---------- Assembled star box (for the cone socket) ---------- */
module star_solid(extra = 0) {
    // full closed box outline, slightly enlarged by `extra` for clearance
    linear_extrude(thickness) star_offset(extra);
}

/* ---------- Conic base ----------
   Modeled in its printing orientation: wide end on the bed, axis = Z.
   In use it is flipped is not needed: tree tip enters from the bottom,
   the star's bottom point snaps into the socket cut in the top. */
module base() {
    difference() {
        cylinder(h = cone_h, r1 = cone_r_bottom, r2 = cone_r_top);
        // tree tip hole from the bottom
        translate([0, 0, -0.01])
            cylinder(h = tree_hole_h, r1 = tree_hole_r, r2 = tree_hole_top);
        // star-tip socket cut into the top: the star (with clearance)
        // positioned tip-down, sunk socket_depth into the cone
        translate([0, 0, cone_h - socket_depth + R])
            rotate([90, 0, 0])
                translate([0, 0, -thickness / 2])
                    star_solid(clearance);
    }
}

/* ---------- Assembly preview ---------- */
module assembly() {
    color("firebrick") front();
    color("darkred") translate([0, 0, thickness]) mirror([0, 0, 1]) back();
    color("goldenrod")
        translate([0, -R + socket_depth - cone_h, thickness / 2])
            rotate([-90, 0, 0]) base();
}

if (part == "front")    front();
if (part == "back")     back();
if (part == "base")     base();
if (part == "assembly") assembly();
