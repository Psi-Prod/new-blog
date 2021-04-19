.PHONY: blogger clean clean-site server reload server-full

blogger:
	dune build

clean:
	dune clean

clean-site:
	rm -rf _site/

server:
	python3 -m http.server --directory _site/

reload: clean clean-site
	dune build
	./src/blogger.exe

server-full: reload
	python3 -m http.server --directory _site/

# Deployment

SHA=`eval "git rev-parse HEAD"`
MSG="Put https://github.com/xhtmlboi/blogger/commit/$(SHA) online!"

init:
	git submodule add https://github.com/xhtmlboi/xhtmlboi.github.io capsule

publish:
	./src/blogger.exe
	git submodule update --remote --merge
	rsync -avr --delete  _site/ capsule/
	cd capsule \
	  && git checkout main \
	  && git add . \
	  && git commit -m "PFIOOOOOU" -m $(MSG) \
	  && git push origin main
	git add capsule
	git commit -m "deploy" -m $(MSG)
	git push