default:
	@echo "Build site - make site"
	@echo "Setup Python VENV - make venv"
	@echo "Destroy Python VENV - make delvenv"

site:
	rm -rf site/
	( . bin/activate && \
		mkdocs build )

venv:
	python3 -m venv .
	( . bin/activate && \
		pip3 install mkdocs wheel mkdocs-print-site-plugin )

delvenv:
	rm -rf bin/ include/ lib/ pyvenv.cfg
	rm -f lib64
	@echo
	@echo "You will need to logout and log back in"
	
