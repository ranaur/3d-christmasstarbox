# Renders all 3 parts (front, back, base) of each of the 4 variants.
#
#   make            -> render everything
#   make flat       -> render one variant (flat, flat_middle, pyramid, pyramid_middle)
#   make clean      -> remove generated STLs
#
# Override the OpenSCAD binary if needed, e.g.:
#   make OPENSCAD="C:/Program Files/OpenSCAD/openscad.com"

OPENSCAD ?= openscad

VARIANTS = flat flat_middle pyramid pyramid_middle
PARTS    = front back base

STLS = $(foreach v,$(VARIANTS),$(foreach p,$(PARTS),$(v)_$(p).stl))

all: $(STLS)

define VARIANT_PART_RULE
$(1)_$(2).stl: star_box_$(1).scad
	"$$(OPENSCAD)" -o $$@ -D 'part="$(2)"' star_box_$(1).scad
endef

$(foreach v,$(VARIANTS),$(foreach p,$(PARTS),$(eval $(call VARIANT_PART_RULE,$(v),$(p)))))

$(foreach v,$(VARIANTS),$(eval $(v): $(foreach p,$(PARTS),$(v)_$(p).stl)))

clean:
	rm -f $(STLS)

.PHONY: all clean $(VARIANTS)
