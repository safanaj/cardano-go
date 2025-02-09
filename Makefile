GOGEN = go generate
GOBUILD = go build
GOTEST = go test

## TODO: check if git and autotools are available to generate dependencies for libsodium
./libsodium/_c_libsodium_built/libsodium.a:
	$(GOGEN) ./libsodium/...
	touch $@

csigner: ./libsodium/_c_libsodium_built/libsodium.a
	CGO_ENABLED=1 \
	CGO_CFLAGS=-I$(CURDIR)/libsodium/_c_libsodium_built/include \
	CGO_LDFLAGS=-L$(CURDIR)/libsodium/_c_libsodium_built \
	$(GOBUILD) -o ./cli/build/$@ cli/$@/main.go

cwallet cpinger:
	$(GOBUILD) -o ./cli/build/$@ cli/$@/main.go

install: cwallet csigner cpinger
	@for x in $^ ; do cp ./cli/build/$${x} /usr/local/bin/ ; done

test:
	$(GOTEST) $(go list ./... | grep -v libsodium | grep -v 'cli/')

testcov:
	$(GOTEST) $(go list ./... | grep -v libsodium | grep -v 'cli/') -coverprofile coverage.out

opencov:
	go tool cover -html coverage.out
