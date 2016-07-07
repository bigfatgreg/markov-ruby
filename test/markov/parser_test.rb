require "test_helper"

describe "Markov::Parser" do

  before do
    @source = "test/fixtures/text_sample.txt"
    @parser = Markov::Parser.new(@source)
  end

  it "initializes with a source" do
    assert_equal @parser.source, @source
  end

  it "reads the source file" do
    assert_equal String, @parser.raw_text.class
  end

  it "groups the words using the raw text" do
    assert_equal @parser.groups(4).length, @parser.raw_text.split.length
    assert_equal @parser.groups(4).last[:prefix], ["insects","on","the"]
    assert_equal @parser.groups(4).last[:suffix], "walls."
  end

  it "groups the words using the tagged text" do
    assert_equal @parser.groups(4, { tagged: true }).length, @parser.tagged_text.split.length
    assert_equal @parser.groups(4, { tagged: true }).last[:prefix], ["on/IN", "the/DET", "walls/NNS"]
    assert_equal @parser.groups(4, { tagged: true }).last[:suffix], "./PP"
  end

end