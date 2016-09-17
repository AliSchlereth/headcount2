require './test/test_helper'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_can_create_statewide_object_for_third_grade
    row = {name: "DENVER", third_grade: {2016=>{"Math"=>0.502}}}
    statewide = StatewideTest.new(row)
    assert_equal "DENVER", statewide.name
    assert_equal ({2016=>{"Math"=>0.502}}), statewide.third_grade
  end

  def test_can_create_statewide_object_for_eighth_grade
    row = {name: "DENVER", eighth_grade: {2016=>{"Writing"=>0.512}}}
    statewide = StatewideTest.new(row)
    assert_equal "DENVER", statewide.name
    assert_equal ({2016=>{"Writing"=>0.512}}), statewide.eighth_grade
  end

  def test_can_create_statewide_object_for_math
    row = {name: "DENVER", math: {"ASIAN" => {2016=>0.512}}}
    statewide = StatewideTest.new(row)

    assert_equal "DENVER", statewide.name
    assert_equal ({"ASIAN" => {2016=>0.512}}), statewide.math
  end

  def test_can_create_statewide_object_for_math
    row = {name: "DENVER", reading: {"ASIAN" => {2016=>0.512}}}
    statewide = StatewideTest.new(row)

    assert_equal "DENVER", statewide.name
    assert_equal ({"ASIAN" => {2016=>0.512}}), statewide.reading
  end

  def test_can_create_statewide_object_for_math
    row = {name: "DENVER", writing: {"ASIAN" => {2016=>0.512}}}
    statewide = StatewideTest.new(row)

    assert_equal "DENVER", statewide.name
    assert_equal ({"ASIAN" => {2016=>0.512}}), statewide.writing
  end

  def test_proficient_by_grade_third
    row = {name: "DENVER", third_grade: {2016=>{"Math"=>0.502}}}
    statewide = StatewideTest.new(row)

    assert_equal ({2016=>{"Math"=>0.502}}), statewide.proficient_by_grade(3)
  end

  def test_proficient_by_grade_eight
    row = {name: "DENVER", eighth_grade: {2016=>{"Math"=>0.502}}}
    statewide = StatewideTest.new(row)

    assert_equal ({2016=>{"Math"=>0.502}}), statewide.proficient_by_grade(8)
  end

  def test_proficient_by_grade_wrong_grade
    row = {name: "DENVER", third_grade: {2016=>{"Math"=>0.502}}}
    statewide = StatewideTest.new(row)

    assert_raises (UnknownDataError) do
      statewide.proficient_by_grade(9)
    end 
  end






end
