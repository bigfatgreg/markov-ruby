require "test_helper"

describe "Markov::Generate" do

  before do
    @generator = Markov::Generate.new("markov_test")
    @source = "test/fixtures/text_sample.txt"
    @dbname = "markov_test"
    @db = Markov::DB.new(dbname: @dbname)
    @db.import("testing", @source)
  end

  it "initializes with defaults" do
    assert_equal @generator.length, 200
    assert_equal @generator.weight, 1.2
    assert_equal @generator.start, "The"
  end
  
  it "has a current word" do
    assert_equal @generator.current_word, @generator.start
  end
  
  it "looks up a word" do
    assert_equal @generator.lookup("the", "testing")[:suffices].length, 581
  end

  after do
    @db.send(:connection, 
             "DELETE FROM word_groups 
              WHERE source = 'testing';")
    @db.send(:connection, "TRUNCATE word_groups_jsonb")
  end

end