// |reftest| skip async -- class-methods-private is not supported
// This file was procedurally generated from the following sources:
// - src/async-generators/yield-spread-obj.case
// - src/async-generators/default/async-class-expr-private-method.template
/*---
description: Use yield value in a object spread position (Async generator method as a ClassExpression element)
esid: prod-AsyncGeneratorPrivateMethod
features: [object-spread, async-iteration, class-methods-private]
flags: [generated, async]
includes: [compareArray.js]
info: |
    ClassElement :
      PrivateMethodDefinition

    MethodDefinition :
      AsyncGeneratorMethod

    Async Generator Function Definitions

    AsyncGeneratorMethod :
      async [no LineTerminator here] * PropertyName ( UniqueFormalParameters ) { AsyncGeneratorBody }


    Spread Properties

    PropertyDefinition[Yield]:
      (...)
      ...AssignmentExpression[In, ?Yield]

---*/


var callCount = 0;

var C = class {
    async *#gen() {
        callCount += 1;
        yield {
            ...yield,
            y: 1,
            ...yield yield,
          };
    }
    get gen() { return this.#gen; }
}

const c = new C();

// Test the private fields do not appear as properties before set to value
assert.sameValue(Object.hasOwnProperty.call(C.prototype, "#gen"), false, 'Object.hasOwnProperty.call(C.prototype, "#gen")');
assert.sameValue(Object.hasOwnProperty.call(C, "#gen"), false, 'Object.hasOwnProperty.call(C, "#gen")');
assert.sameValue(Object.hasOwnProperty.call(c, "#gen"), false, 'Object.hasOwnProperty.call(c, "#gen")');

var iter = c.gen();

iter.next();
iter.next({ x: 42 });
iter.next({ x: 'lol' });
var item = iter.next({ y: 39 });

item.then(({ done, value }) => {
  assert.sameValue(value.x, 42);
  assert.sameValue(value.y, 39);
  assert.sameValue(Object.keys(value).length, 2);
  assert.sameValue(done, false);
}).then($DONE, $DONE);

assert.sameValue(callCount, 1);

// Test the private fields do not appear as properties after set to value
assert.sameValue(Object.hasOwnProperty.call(C.prototype, "#gen"), false, 'Object.hasOwnProperty.call(C.prototype, "#gen")');
assert.sameValue(Object.hasOwnProperty.call(C, "#gen"), false, 'Object.hasOwnProperty.call(C, "#gen")');
assert.sameValue(Object.hasOwnProperty.call(c, "#gen"), false, 'Object.hasOwnProperty.call(c, "#gen")');
