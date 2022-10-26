describe :array_eql, shared: true do
  it "returns true if other is the same array" do
    a = [1]
    expect(a.send(@method, a)).to be_true
  end

  it "returns true if corresponding elements are #eql?" do
    expect([].send(@method, [])).to be_true
    expect([1, 2, 3, 4].send(@method, [1, 2, 3, 4])).to be_true
  end

  it "returns false if other is shorter than self" do
    expect([1, 2, 3, 4].send(@method, [1, 2, 3])).to be_false
  end

  it "returns false if other is longer than self" do
    expect([1, 2, 3, 4].send(@method, [1, 2, 3, 4, 5])).to be_false
  end

  it "returns false immediately when sizes of the arrays differ" do
    obj = double('1')
    expect(obj).not_to receive(@method)

    expect([]        .send(@method,    [obj]  )).to be_false
    expect([obj]     .send(@method,    []     )).to be_false
  end

  it "handles well recursive arrays" do
    a = ArraySpecs.empty_recursive_array
    expect(a       .send(@method,    [a]    )).to be_true
    expect(a       .send(@method,    [[a]]  )).to be_true
    expect([a]     .send(@method,    a      )).to be_true
    expect([[a]]   .send(@method,    a      )).to be_true
    # These may be surprising, but no difference can be
    # found between these arrays, so they are ==.
    # There is no "path" that will lead to a difference
    # (contrary to other examples below)

    a2 = ArraySpecs.empty_recursive_array
    expect(a       .send(@method,    a2     )).to be_true
    expect(a       .send(@method,    [a2]   )).to be_true
    expect(a       .send(@method,    [[a2]] )).to be_true
    expect([a]     .send(@method,    a2     )).to be_true
    expect([[a]]   .send(@method,    a2     )).to be_true

    back = []
    forth = [back]; back << forth;
    expect(back   .send(@method,  a  )).to be_true

    x = []; x << x << x
    expect(x       .send(@method,    a                )).to be_false  # since x.size != a.size
    expect(x       .send(@method,    [a, a]           )).to be_false  # since x[0].size != [a, a][0].size
    expect(x       .send(@method,    [x, a]           )).to be_false  # since x[1].size != [x, a][1].size
    expect([x, a]  .send(@method,    [a, x]           )).to be_false  # etc...
    expect(x       .send(@method,    [x, x]           )).to be_true
    expect(x       .send(@method,    [[x, x], [x, x]] )).to be_true

    tree = [];
    branch = []; branch << tree << tree; tree << branch
    tree2 = [];
    branch2 = []; branch2 << tree2 << tree2; tree2 << branch2
    forest = [tree, branch, :bird, a]; forest << forest
    forest2 = [tree2, branch2, :bird, a2]; forest2 << forest2

    expect(forest .send(@method,     forest2         )).to be_true
    expect(forest .send(@method,     [tree2, branch, :bird, a, forest2])).to be_true

    diffforest = [branch2, tree2, :bird, a2]; diffforest << forest2
    expect(forest .send(@method,     diffforest      )).to be_false # since forest[0].size == 1 != 3 == diffforest[0]
    expect(forest .send(@method,     [nil]           )).to be_false
    expect(forest .send(@method,     [forest]        )).to be_false
  end

  it "does not call #to_ary on its argument" do
    obj = double('to_ary')
    expect(obj).not_to receive(:to_ary)

    expect([1, 2, 3].send(@method, obj)).to be_false
  end

  it "does not call #to_ary on Array subclasses" do
    ary = ArraySpecs::ToAryArray[5, 6, 7]
    expect(ary).not_to receive(:to_ary)
    expect([5, 6, 7].send(@method, ary)).to be_true
  end

  it "ignores array class differences" do
    expect(ArraySpecs::MyArray[1, 2, 3].send(@method, [1, 2, 3])).to be_true
    expect(ArraySpecs::MyArray[1, 2, 3].send(@method, ArraySpecs::MyArray[1, 2, 3])).to be_true
    expect([1, 2, 3].send(@method, ArraySpecs::MyArray[1, 2, 3])).to be_true
  end
end
