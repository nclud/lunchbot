NPM_EXECUTABLE_HOME := node_modules/.bin

PATH := ${NPM_EXECUTABLE_HOME}:${PATH}

test: deps
	@find test -name '*.coffee' | xargs -n 1 -t node_modules/hubot/node_modules/coffee-script/bin/coffee

deps:

.PHONY: all

