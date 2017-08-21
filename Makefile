ISSUES_JSONS = $(shell find repos -name "issues.json")

TIMELINES = $(patsubst repos/%/issues.json,repos/%/timeline.tsv,$(ISSUES_JSONS))
CFD_PNGS = $(patsubst repos/%/issues.json,repos/%/cfd.png,$(ISSUES_JSONS))
OPEN_PNGS = $(patsubst repos/%/issues.json,repos/%/open.png,$(ISSUES_JSONS))
LT_PNGS = $(patsubst repos/%/issues.json,repos/%/lt.png,$(ISSUES_JSONS))
LTS_PNGS = $(patsubst repos/%/issues.json,repos/%/lts.png,$(ISSUES_JSONS))

all: $(CFD_PNGS) $(OPEN_PNGS) $(LT_PNGS) $(LTS_PNGS)

repos/%/cfd.png: repos/%/timeline.tsv scripts/cfd.gpi
	gnuplot -e "tsv='$<'" scripts/cfd.gpi > $@

repos/%/open.png: repos/%/timeline.tsv scripts/open.gpi
	gnuplot -e "tsv='$<'" scripts/open.gpi > $@

repos/%/lt.png: repos/%/timeline.tsv scripts/lt.gpi
	gnuplot -e "tsv='$<'" scripts/lt.gpi > $@

repos/%/lts.png: repos/%/timeline.tsv scripts/lts.gpi
	gnuplot -e "tsv='$<'" scripts/lts.gpi > $@

.PRECIOUS: repos/%/timeline.tsv
repos/%/timeline.tsv: repos/%/issues.json bin/ghis lib/ghis.rb
	ruby -Ilib bin/ghis $< > $@
