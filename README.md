# 3D Christmas Star Box

A 3D-printable Christmas star tree topper that doubles as a small box.
Designed in [OpenSCAD](https://openscad.org/) — fully parametric, all
dimensions can be tweaked at the top of each `star_box_*.scad` file.

There are 4 versions: Flat vs. Pyramid, and Default vs. Middle:

- **Flat** (`star_box_flat*.scad`) — the box has flat front and back
  faces.
- **Pyramid** (`star_box_pyramid*.scad`) — each half rises to a peak in
  the middle (classic 3D star look), sitting on a small straight rim
  (`rim_h`, default 5 mm) that carries the snap fit.
- **Default** (`star_box_flat.scad`, `star_box_pyramid.scad`) — the
  star's bottom point sinks into a star-shaped socket in the base.
- **Middle** (`star_box_flat_middle.scad`,
  `star_box_pyramid_middle.scad`) — a round mounting shaft between the
  two bottom star points inserts into a round socket in the base.

## How it works

- The **front** and **back** are star-shaped half-shells that snap
  together to close the box (snap ridge/tongue on the back clicks into a
  groove in the front, `clearance` = 0.25 mm).
- The **conic base** slides over the tip of the tree from below and
  locks the two halves together — via the bottom star point (default
  versions) or the mounting shaft (middle versions).
- In the middle versions each half carries a half-round shaft in the
  valley between the two bottom points; when the halves snap together
  they form a round shaft.

### Shaft parameters (middle versions)

| Parameter | Meaning | Default (flat / pyramid) |
|-----------|---------|--------------------------|
| `shaft_r` | Shaft radius | 6 / 4.75 mm |
| `shaft_len` | Protrusion past the star valley | 25 mm |
| `shaft_embed` | Root depth into the star body | 6 mm |
| `socket_depth` | Socket depth in the cone | 20 / 15 mm |

Keep `shaft_r` below `thickness / 2` (flat) or `rim_h` (pyramid).

## Parts

Each version renders three parts:

| Part | Description | Print orientation |
|------|-------------|-------------------|
| `front` | Front half-shell | Flat: face on the bed. Pyramid: rim on the bed, apex up |
| `back`  | Back half-shell with snap lip/tongue | Flat: face on the bed. Pyramid: tongue on the bed, apex up |
| `base`  | Conic base / tree-tip collar | Wide end on the bed |

Included STLs: `<variant>_<part>.stl` for every combination, e.g.
`flat_front.stl`, `pyramid_middle_base.stl`.

Print notes:

- Flat middle: the half-round shaft overhangs at the mating plane when
  the face is on the bed — enable supports under the shaft.
- Pyramid: the hollow interior of the pyramid faces are shallow
  overhangs — print with supports, solid infill, or increase `peak` for
  steeper facets.

## Default dimensions

- Star: 150 mm tip-to-tip; flat: 40 mm deep, 2 mm walls; pyramid:
  28 mm peak per half on a 5 mm rim, 2.4 mm walls
- Cone: 50–60 mm tall depending on version, fits a tree tip up to
  ~22–26 mm diameter
- Fit clearance: 0.25 mm (adjust `clearance` for your printer)

## Regenerating the STLs

With GNU make and OpenSCAD on the PATH:

```sh
make                # all 12 STLs (3 parts x 4 variants)
make pyramid_middle # one variant
make OPENSCAD="C:/Program Files/OpenSCAD/openscad.com"  # custom binary
```

Or render a single part directly:

```sh
openscad -o flat_front.stl -D part=\"front\" star_box_flat.scad
```

Set `part = "assembly"` in the file (or via `-D`) to preview the whole
assembly in the OpenSCAD GUI.

## Print settings (suggested)

- Material: PETG or PLA
- Layer height: 0.2 mm, 2–3 perimeters
- If the snap fit is too tight/loose, tune `clearance` and `bump`

## Credits & license

This project was heavily made by AI ([Devin](https://devin.ai) — design,
OpenSCAD code, STLs and docs), directed by a human.

Released under [CC0 1.0](LICENSE) — public domain dedication. Use it,
remix it, print it, sell it; no attribution required.
