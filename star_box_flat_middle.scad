// Christmas Star Tree-Topper Box
// Three printable parts:
//   part = "front"    -> front half-shell (star shaped, prints face down)
//   part = "back"     -> back half-shell with snap lip (prints face down)
//   part = "base"     -> conic base that slides over the tree tip and
//                        locks the two halves via the mounting shaft
//                        between the two bottom star points
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
star_rot      = 36;            // one point straight up, valley straight down

/* ---------- Mounting shaft (between the two bottom points) ---------- */
shaft_r       = 6;             // shaft radius (keep below thickness / 2)
shaft_len     = 25;            // how far the shaft protrudes past the valley
shaft_embed   = 6;             // how far the shaft roots into the star body

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
socket_depth  = 20;            // how deep the shaft sinks into the cone
tree_hole_r   = 13;            // tree tip hole radius at the bottom
tree_hole_top = 5;             // tree tip hole radius at the top of the hole
tree_hole_h   = 34;            // tree tip hole depth (from the bottom)

$fn = 96;
half = thickness / 2;

/* ---------- 2D star ---------- */
module star2d() {
    polygon([for (i = [0 : 2 * star_points - 1])
        let (a = -90 + star_rot + i * 180 / star_points,
             rad = (i % 2 == 0) ? R : r)
        [rad * cos(a), rad * sin(a)]]);
}

module star_offset(d) { offset(delta = d) star2d(); }

/* ---------- Half mounting shaft ----------
   Half-round shaft along -Y at the bottom valley; the shaft axis lies in
   the mating plane (z = half), so front and back each carry one half and
   form a round shaft when snapped together. */
module half_shaft() {
    intersection() {
        translate([0, -(r - shaft_embed), half])
            rotate([90, 0, 0])
                cylinder(h = shaft_len + shaft_embed, r = shaft_r);
        translate([-2 * R, -2 * R, half - 2 * shaft_r])
            cube([4 * R, 4 * R, 2 * shaft_r]);
    }
}

/* ---------- Front half-shell ----------
   Prints as modeled: outer face on the bed (z = 0), cavity opening up. */
module front() {
    half_shaft();
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
    half_shaft();
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

/* ---------- Conic base ----------
   Modeled in its printing orientation: wide end on the bed, axis = Z.
   Tree tip enters from the bottom, the star's mounting shaft inserts
   into the round socket cut in the top. */
module base() {
    difference() {
        cylinder(h = cone_h, r1 = cone_r_bottom, r2 = cone_r_top);
        // tree tip hole from the bottom
        translate([0, 0, -0.01])
            cylinder(h = tree_hole_h, r1 = tree_hole_r, r2 = tree_hole_top);
        // shaft socket
        translate([0, 0, cone_h - socket_depth])
            cylinder(h = socket_depth + 0.01, r = shaft_r + clearance);
    }
}

/* ---------- Assembly preview ---------- */
module assembly() {
    color("firebrick") front();
    color("darkred") translate([0, 0, thickness]) mirror([0, 0, 1]) back();
    color("goldenrod")
        translate([0, -(r + shaft_len) + socket_depth - cone_h, half])
            rotate([-90, 0, 0]) base();
}

if (part == "front")    front();
if (part == "back")     back();
if (part == "base")     base();
if (part == "assembly") assembly();
