# 3D Christmas Star Box

A 3D-printable Christmas star tree topper that doubles as a small box.
Designed in [OpenSCAD](https://openscad.org/) — fully parametric, all
dimensions can be tweaked at the top of `star_box.scad`.

## Parts

| File | Part | Print orientation |
|------|------|-------------------|
| `front.stl` | Front half-shell (star) | As exported — flat face on the bed |
| `back.stl`  | Back half-shell with snap lip | As exported — flat face on the bed |
| `base.stl`  | Conic base / tree-tip collar | As exported — wide end on the bed |

### Pyramidal version (`star_box_pyramid.scad`)

Faceted variant where both halves rise to a peak in the middle (classic
3D star look) and sit on a small straight rim (`rim_h`, default 5 mm)
that carries the snap fit — a tongue on the back clicks into a groove in
the front rim.

| File | Part | Print orientation |
|------|------|-------------------|
| `pyramid_front.stl` | Front pyramidal half-shell | Rim on the bed, apex up |
| `pyramid_back.stl`  | Back pyramidal half-shell (snap tongue) | Tongue on the bed, apex up |
| `pyramid_base.stl`  | Conic base (socket matches the pyramidal star) | Wide end on the bed |

The hollow interior of the pyramid faces are shallow overhangs — print
with supports, solid infill, or increase `peak` for steeper facets.

## How it works

- The **front** and **back** are star-shaped trays. The back has an inner
  lip with a snap ridge that clicks into a matching groove inside the
  front, closing the box.
- The **conic base** slides over the tip of the tree from below. The
  star's bottom point sinks into a star-shaped socket cut into the top of
  the cone, locking the two halves together.

## Default dimensions

- Star: 150 mm tip-to-tip, 40 mm deep, 2 mm walls
- Cone: 60 mm tall, fits a tree tip up to ~26 mm diameter
- Fit clearance: 0.25 mm (adjust `clearance` for your printer)

## Regenerating the STLs

```sh
openscad -o front.stl -D part=\"front\" star_box.scad
openscad -o back.stl  -D part=\"back\"  star_box.scad
openscad -o base.stl  -D part=\"base\"  star_box.scad
```

Set `part = "assembly"` in the file (or via `-D`) to preview the whole
assembly in the OpenSCAD GUI.

## Print settings (suggested)

- Material: PETG or PLA
- Layer height: 0.2 mm, 2–3 perimeters, no supports needed
- If the snap fit is too tight/loose, tune `clearance` and `bump`
