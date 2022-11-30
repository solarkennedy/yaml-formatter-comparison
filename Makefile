OUTPUTS=python-yamlfmt.out.yaml google-yamlfmt.out.yaml precommit-yamlfmt.out.yaml prettier.out.yaml
.PHONY: all
all: $(OUTPUTS)

clean:
	rm $(OUTPUTS)

build:
	docker build -t yaml-formatter-comparison .

google-yamlfmt.out.yaml: in.yaml
	cp in.yaml tmp.yaml
	docker run -v ${PWD}:/work/:rw yaml-formatter-comparison google-yamlfmt /work/tmp.yaml
	mv tmp.yaml $@

precommit-yamlfmt.out.yaml: in.yaml
	cp in.yaml tmp.yaml
	docker run -v ${PWD}:/work/:rw yaml-formatter-comparison pre-commit-yamlfmt /work/tmp.yaml
	mv tmp.yaml $@

python-yamlfmt.out.yaml: in.yaml
	cp in.yaml tmp.yaml
	docker run -v ${PWD}:/work/:rw yaml-formatter-comparison python-yamlfmt --write /work/tmp.yaml
	mv tmp.yaml $@

prettier.out.yaml: in.yaml
	cp in.yaml tmp.yaml
	docker run -v ${PWD}:/work/:rw yaml-formatter-comparison prettier --write /work/tmp.yaml
	mv tmp.yaml $@

report: all
	@echo "Diff between input and google-yamlfmt:"
	@diff in.yaml google-yamlfmt.out.yaml || true
	@echo ""
	
	@echo "Diff between input and precommit-yamlfmt:"
	@diff in.yaml precommit-yamlfmt.out.yaml || true
	@echo ""
		
	@echo "Diff between input and python-yamlfmt:"
	@diff in.yaml python-yamlfmt.out.yaml || true
	@echo ""
	
	@echo "Diff between input and prettier:"
	@diff in.yaml prettier.out.yaml || true
	@echo ""
