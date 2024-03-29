library angular2.test.change_detection.pipes.pipes_spec;

import "package:angular2/test_lib.dart"
    show
        ddescribe,
        describe,
        it,
        iit,
        xit,
        expect,
        beforeEach,
        afterEach,
        SpyPipe,
        SpyPipeFactory;
import "package:angular2/di.dart" show Injector, bind;
import "package:angular2/src/change_detection/pipes/pipes.dart" show Pipes;
import "package:angular2/src/change_detection/pipes/pipe.dart" show PipeFactory;

main() {
  describe("pipe registry", () {
    var firstPipe;
    var secondPipe;
    var firstPipeFactory;
    var secondPipeFactory;
    beforeEach(() {
      firstPipe = (new SpyPipe() as dynamic);
      secondPipe = (new SpyPipe() as dynamic);
      firstPipeFactory = (new SpyPipeFactory() as dynamic);
      secondPipeFactory = (new SpyPipeFactory() as dynamic);
    });
    it("should return an existing pipe if it can support the passed in object",
        () {
      var r = new Pipes({"type": []});
      firstPipe.spy("supports").andReturn(true);
      expect(r.get("type", "some object", null, firstPipe)).toEqual(firstPipe);
    });
    it("should call onDestroy on the provided pipe if it cannot support the provided object",
        () {
      firstPipe.spy("supports").andReturn(false);
      firstPipeFactory.spy("supports").andReturn(true);
      firstPipeFactory.spy("create").andReturn(secondPipe);
      var r = new Pipes({"type": [firstPipeFactory]});
      expect(r.get("type", "some object", null, firstPipe)).toEqual(secondPipe);
      expect(firstPipe.spy("onDestroy")).toHaveBeenCalled();
    });
    it("should return the first pipe supporting the data type", () {
      firstPipeFactory.spy("supports").andReturn(false);
      firstPipeFactory.spy("create").andReturn(firstPipe);
      secondPipeFactory.spy("supports").andReturn(true);
      secondPipeFactory.spy("create").andReturn(secondPipe);
      var r = new Pipes({"type": [firstPipeFactory, secondPipeFactory]});
      expect(r.get("type", "some object")).toBe(secondPipe);
    });
    it("should throw when no matching type", () {
      var r = new Pipes({});
      expect(() => r.get("unknown", "some object")).toThrowError(
          '''Cannot find \'unknown\' pipe supporting object \'some object\'''');
    });
    it("should throw when no matching pipe", () {
      var r = new Pipes({"type": []});
      expect(() => r.get("type", "some object")).toThrowError(
          '''Cannot find \'type\' pipe supporting object \'some object\'''');
    });
    describe(".create()", () {
      it("should create a new Pipes object", () {
        firstPipeFactory.spy("supports").andReturn(true);
        firstPipeFactory.spy("create").andReturn(firstPipe);
        var pipes = Pipes.create({"async": [firstPipeFactory]});
        expect(pipes.get("async", "first")).toBe(firstPipe);
      });
      it("should prepend passed it config in existing registry", () {
        firstPipeFactory.spy("supports").andReturn(true);
        secondPipeFactory.spy("supports").andReturn(true);
        secondPipeFactory.spy("create").andReturn(secondPipe);
        var pipes1 = Pipes.create({"async": [firstPipeFactory]});
        var pipes2 = Pipes.create({"async": [secondPipeFactory]}, pipes1);
        expect(pipes2.get("async", "first")).toBe(secondPipe);
      });
      it("should use inherited pipes when no overrides support the provided object",
          () {
        firstPipeFactory.spy("supports").andReturn(true);
        firstPipeFactory.spy("create").andReturn(firstPipe);
        secondPipeFactory.spy("supports").andReturn(false);
        var pipes1 = Pipes
            .create({"async": [firstPipeFactory], "date": [firstPipeFactory]});
        var pipes2 = Pipes.create({"async": [secondPipeFactory]}, pipes1);
        expect(pipes2.get("async", "first")).toBe(firstPipe);
        expect(pipes2.get("date", "first")).toBe(firstPipe);
      });
    });
    describe(".extend()", () {
      it("should create a factory that prepend new pipes to old", () {
        firstPipeFactory.spy("supports").andReturn(true);
        secondPipeFactory.spy("supports").andReturn(true);
        secondPipeFactory.spy("create").andReturn(secondPipe);
        var originalPipes = new Pipes({"async": [firstPipeFactory]});
        var binding =
            Pipes.extend({"async": ([secondPipeFactory] as List<PipeFactory>)});
        Pipes pipes = binding.toFactory(originalPipes);
        expect(pipes.config["async"].length).toBe(2);
        expect(originalPipes.config["async"].length).toBe(1);
        expect(pipes.get("async", "second plz")).toBe(secondPipe);
      });
      it("should throw if calling extend when creating root injector", () {
        secondPipeFactory.spy("supports").andReturn(true);
        secondPipeFactory.spy("create").andReturn(secondPipe);
        Injector injector = Injector
            .resolveAndCreate([Pipes.extend({"async": [secondPipeFactory]})]);
        expect(() => injector.get(Pipes))
            .toThrowErrorWith("Cannot extend Pipes without a parent injector");
      });
      it("should extend di-inherited pipes", () {
        firstPipeFactory.spy("supports").andReturn(true);
        firstPipeFactory.spy("create").andReturn(firstPipe);
        secondPipeFactory.spy("supports").andReturn(false);
        Pipes originalPipes = new Pipes({"async": [firstPipeFactory]});
        Injector injector =
            Injector.resolveAndCreate([bind(Pipes).toValue(originalPipes)]);
        Injector childInjector = injector.resolveAndCreateChild(
            [Pipes.extend({"async": [secondPipeFactory]})]);
        Pipes parentPipes = injector.get(Pipes);
        Pipes childPipes = childInjector.get(Pipes);
        expect(childPipes.config["async"].length).toBe(2);
        expect(parentPipes.config["async"].length).toBe(1);
        expect(childPipes.get("async", "second plz")).toBe(firstPipe);
      });
    });
  });
}
