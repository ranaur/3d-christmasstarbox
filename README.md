# 3D Christmas Star Box

A 3D-printable Christmas star tree topper that doubles as a small box.
Designed in [OpenSCAD](https://openscad.org/) — fully parametric, all
dimensions can be tweaked at the top of each `.scad` file.

Two variants are included:

- **Flat version** (`star_box.scad`) — flat-faced star halves.
- **Pyramidal version** (`star_box_pyramid.scad`) — faceted halves that
  rise to a peak in the middle (classic 3D star look), sitting on a
  small straight rim (`rim_h`, default 5 mm) that carries the snap fit.

## How it works

- The **front** and **back** are star-shaped half-shells that snap
  together to close the box (snap ridge/tongue on the back clicks into a
  groove in the front, `clearance` = 0.25 mm).
- Each half carries a half-round **mounting shaft** in the valley
  between the two bottom star points; when the halves snap together they
  form a round shaft.
- The **conic base** slides over the tip of the tree from below. The
  mounting shaft inserts into a round socket in the top of the cone,
  locking the two halves together.

### Shaft parameters

| Parameter | Meaning | Default (flat / pyramidal) |
|-----------|---------|----------------------------|
| `shaft_r` | Shaft radius | 6 / 4.75 mm |
| `shaft_len` | Protrusion past the star valley | 25 mm |
| `shaft_embed` | Root depth into the star body | 6 mm |
| `socket_depth` | Socket depth in the cone | 20 / 15 mm |

Keep `shaft_r` below `thickness / 2` (flat) or `rim_h` (pyramidal).

## Parts

### Flat version (`star_box.scad`)

| File | Part | Print orientation |
|------|------|-------------------|
| `front.stl` | Front half-shell (star) | As exported — flat face on the bed |
| `back.stl`  | Back half-shell with snap lip | As exported — flat face on the bed |
| `base.stl`  | Conic base / tree-tip collar | As exported — wide end on the bed |

The half-round shaft sits at the mating plane, so it overhangs when the
flat face is on the bed — enable supports (or just support the shaft).

### Pyramidal version (`star_box_pyramid.scad`)

| File | Part | Print orientation |
|------|------|-------------------|
| `pyramid_front.stl` | Front pyramidal half-shell | Rim on the bed, apex up |
| `pyramid_back.stl`  | Back pyramidal half-shell (snap tongue) | Tongue on the bed, apex up |
| `pyramid_base.stl`  | Conic base (round socket for the mounting shaft) | Wide end on the bed |

The hollow interior of the pyramid faces are shallow overhangs — print
with supports, solid infill, or increase `peak` for steeper facets.

## Default dimensions

- Star: 150 mm tip-to-tip; flat: 40 mm deep, 2 mm walls; pyramidal:
  28 mm peak per half on a 5 mm rim, 2.4 mm walls
- Cone: 60 mm (flat) / 50 mm (pyramidal) tall, fits a tree tip up to
  ~26 mm / ~22 mm diameter
- Fit clearance: 0.25 mm (adjust `clearance` for your printer)

## Regenerating the STLs

```sh
openscad -o front.stl -D part=\"front\" star_box.scad
openscad -o back.stl  -D part=\"back\"  star_box.scad
openscad -o base.stl  -D part=\"base\"  star_box.scad

openscad -o pyramid_front.stl -D part=\"front\" star_box_pyramid.scad
openscad -o pyramid_back.stl  -D part=\"back\"  star_box_pyramid.scad
openscad -o pyramid_base.stl  -D part=\"base\"  star_box_pyramid.scad
```

Set `part = "assembly"` in the file (or via `-D`) to preview the whole
assembly in the OpenSCAD GUI.

## Print settings (suggested)

- Material: PETG or PLA
- Layer height: 0.2 mm, 2–3 perimeters
- If the snap fit is too tight/loose, tune `clearance` and `bump`
