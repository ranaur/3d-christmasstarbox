// Christmas Star Tree-Topper Box — pyramidal version
// Like star_box.scad, but the front and back are faceted star pyramids
// (higher in the middle) sitting on a small straight rim that carries
// the snap fit.
//
// Parts:
//   part = "front"    -> front pyramidal half-shell (prints rim down)
//   part = "back"     -> back pyramidal half-shell with snap tongue
//   part = "base"     -> conic base locking the halves at the bottom point
//   part = "assembly" -> preview of all parts assembled
//
// Render STLs with:
//   openscad -o front.stl -D part=\"front\" star_box_pyramid.scad
//
// All dimensions in millimeters.

part = "assembly";

/* ---------- Star parameters ---------- */
star_points   = 5;
R             = 75;            // outer radius -> 150 mm tip-to-tip
r             = R * 0.382;     // inner radius of the pentagram
peak          = 28;            // pyramid height (apex above the rim)
rim_h         = 5;             // straight rim height per half (the "base")
wall          = 2.4;           // wall thickness
clearance     = 0.25;          // printing clearance for fits

/* ---------- Snap-fit parameters ---------- */
lip_p         = 4;             // how far the back tongue protrudes past its rim
bump          = 0.3;           // snap ridge interference
ridge_h       = 1.2;           // snap ridge band height
groove_h      = 1.8;           // groove band height (slightly taller)
ridge_z0      = 0.8;           // ridge start, measured from the tongue tip

/* ---------- Conic base parameters ---------- */
cone_h        = 60;
cone_r_bottom = 30;
cone_r_top    = 24;
socket_depth  = 22;            // how deep the star bottom tip sinks into the cone
tree_hole_r   = 13;
tree_hole_top = 5;
tree_hole_h   = 34;

$fn = 96;

/* ---------- 2D star ---------- */
module star2d() {
    polygon([for (i = [0 : 2 * star_points - 1])
        let (a = -90 + i * 180 / star_points,
             rad = (i % 2 == 0) ? R : r)
        [rad * cos(a), rad * sin(a)]]);
}

module star_offset(d) { offset(delta = d) star2d(); }

// ring between two offsets of the star outline, extruded h at z0
module ring(o_out, o_in, z0, h) {
    translate([0, 0, z0])
        linear_extrude(h) difference() {
            star_offset(o_out);
            star_offset(o_in);
        }
}

/* ---------- Pyramidal half-shell (rim + faceted star pyramid) ----------
   Modeled in print orientation: open face / rim at z = 0, apex up.
   Inner pyramid faces are shallow overhangs — print with supports or
   solid infill, or increase `peak` for steeper facets. */
module half_shell(rim = rim_h) {
    // rim ring
    ring(0, -wall, 0, rim);
    // pyramid shell: outer faceted pyramid minus inner cavity pyramid
    translate([0, 0, rim]) difference() {
        linear_extrude(peak, scale = 0.01) star_offset(0);
        translate([0, 0, -0.01])
            linear_extrude(peak - wall, scale = 0.01) star_offset(-wall);
    }
}

/* ---------- Front: recess + snap groove in the rim ---------- */
module front() {
    difference() {
        half_shell();
        // recess for the back tongue: inner half of the rim wall removed
        ring(-wall / 2, -wall - 0.1, -0.01, lip_p + 0.06);
        // snap groove in the recess wall
        ring(-wall / 2 + bump + 0.05, -wall - 0.1,
             lip_p - ridge_z0 - ridge_h - (groove_h - ridge_h) / 2, groove_h);
    }
}

/* ---------- Back: protruding tongue with snap ridge ---------- */
module back() {
    // tongue (tip on the bed at z = 0), mating plane at z = lip_p
    ring(-wall / 2 - clearance, -wall, 0, lip_p + 0.01);
    // snap ridge near the tongue tip
    ring(-wall / 2 - clearance + bump, -wall, ridge_z0, ridge_h);
    // rim and pyramid above the mating plane
    translate([0, 0, lip_p]) half_shell();
}

/* ---------- Assembled outer solid (for the cone socket) ---------- */
module half_outer(extra = 0) {
    linear_extrude(rim_h) star_offset(extra);
    translate([0, 0, rim_h])
        linear_extrude(peak, scale = 0.01) star_offset(extra);
}

module star_solid(extra = 0) {
    // mating plane at z = 0, symmetric halves
    half_outer(extra);
    mirror([0, 0, 1]) half_outer(extra);
}

/* ---------- Conic base ----------
   Modeled in print orientation: wide end on the bed, axis = Z. */
module base() {
    difference() {
        cylinder(h = cone_h, r1 = cone_r_bottom, r2 = cone_r_top);
        translate([0, 0, -0.01])
            cylinder(h = tree_hole_h, r1 = tree_hole_r, r2 = tree_hole_top);
        // star-tip socket: assembled star (with clearance), tip down,
        // sunk socket_depth into the cone top
        translate([0, 0, cone_h - socket_depth + R])
            rotate([90, 0, 0])
                star_solid(clearance);
    }
}

/* ---------- Assembly preview ---------- */
module assembly() {
    color("firebrick") mirror([0, 0, 1]) front();
    color("darkred") translate([0, 0, -lip_p]) back();
    color("goldenrod")
        translate([0, -R + socket_depth - cone_h, 0])
            rotate([-90, 0, 0]) base();
}

if (part == "front")    front();
if (part == "back")     back();
if (part == "base")     base();
if (part == "assembly") assembly();
