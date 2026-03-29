C_COMPILER     ?= gcc
BUILD_TYPE     ?= Release
INSTALL_PREFIX ?= /usr/local
CFLAGS         ?= '-Wextra -Wall -Wpedantic'

default: all

.PHONY: all install unit-test test clean

# To add sqlite3 support add -DHCC_LINK_SQLITE3=1 to the below like so:
#```
#all:
#	cmake -S ./src -B ./build -G 'Unix Makefiles' \
#		-DCMAKE_C_COMPILER=$(_C_COMPILER) \
#		-DCMAKE_BUILD_TYPE=$(_BUILD_TYPE) \
#		-DHCC_LINK_SQLITE3=1 \
#		&& $(MAKE) -C ./build -j2
#```

all:
	cmake -S ./src \
		-B ./build \
		-G 'Unix Makefiles' \
		-DCMAKE_C_COMPILER=$(C_COMPILER) \
		-DCMAKE_BUILD_TYPE=$(BUILD_TYPE) \
		-DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) \
		-DCMAKE_C_FLAGS=$(CFLAGS) \
		&& $(MAKE) -C ./build -j2

install:
	$(MAKE) -C ./build install

unit-test:
	$(MAKE) -C ./build unit-test

test: all
	@set -u; \
	HCC_BIN="$$(pwd)/hcc"; \
	TEST_DIR="./src/tests"; \
	FAILED=0; \
	PASSED=0; \
	TOTAL=0; \
	echo "==> Running HolyC tests from $$TEST_DIR"; \
	for test_file in "$$TEST_DIR"/*.HC; do \
		test_name="$$(basename "$$test_file")"; \
		case "$$test_name" in \
			run.HC|testhelper.HC) continue ;; \
		esac; \
		case "$$test_name" in \
			32_sql.HC) \
				if ! grep -q "HCC_LINK_SQLITE3:BOOL=1" ./build/CMakeCache.txt 2>/dev/null; then \
					echo "---- SKIP $$test_name (sqlite3 disabled)"; \
					continue; \
				fi ;; \
		esac; \
		TOTAL=$$((TOTAL+1)); \
		bin_name="$${test_name%.HC}.bin"; \
		bin_path="$$TEST_DIR/$$bin_name"; \
		echo "---- [$$TOTAL] COMPILE $$test_name"; \
		if (cd "$$TEST_DIR" && "$$HCC_BIN" "$$test_name" -o "$$bin_name"); then \
			echo "---- [$$TOTAL] RUN $$test_name"; \
			if (cd "$$TEST_DIR" && "./$$bin_name"); then \
				PASSED=$$((PASSED+1)); \
			else \
				FAILED=$$((FAILED+1)); \
			fi; \
		else \
			FAILED=$$((FAILED+1)); \
		fi; \
		rm -f "$$bin_path"; \
		rm -f "$$TEST_DIR/_test.db"; \
	done; \
	rm -f "$$TEST_DIR"/a.out "$$TEST_DIR"/test-runner "$$TEST_DIR"/*.bin "$$TEST_DIR"/_test.db; \
	echo "==> Test summary: total=$$TOTAL passed=$$PASSED failed=$$FAILED"; \
	if [ "$$FAILED" -ne 0 ]; then \
		exit 1; \
	fi

clean:
	rm -rf ./build ./hcc
