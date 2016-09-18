require './test/test_helper'
require './lib/district_repository'

class DistrictRepostoryTest < Minitest::Test

  # def test_load_data_takes_a_hash_for_loading
  #   dr = DistrictRepository.new
  #   data = {:enrollment => {
  #     :kindergarten => "./data/Kindergartners in full-day program.csv"
  #   }}
  #
  #   assert_instance_of Hash, dr.load_data(data)
  # end
  # could use mock to prove that load data calls parse data
  # could use mock to prove that load data calls EnrollmentRepository load data

  def test_parse_data_creates_district_objects
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)

    assert_instance_of District, dr.districts.values[0]
  end

  def test_parse_data_only_creates_one_instance_for_each_district
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)

    assert_equal 1, dr.districts.keys.count("COLORADO")
  end

  def test_search_by_name_returns_a_district_object
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)

    assert_instance_of District, dr.find_by_name("COLORADO")
  end

  def test_user_can_access_district_information_using_search_by_name
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)

    assert_equal "ACADEMY 20", dr.find_by_name("Academy 20").name
  end

  def test_search_by_name_returns_nil_if_passed_invalid_district_name
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)

    assert_equal nil, dr.find_by_name("ELMO")
  end

  def test_find_all_matching_searches_by_substring_of_name_returning_in_an_array
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)

    assert_instance_of Array, dr.find_all_matching("ADAMS")
    assert_equal 2, dr.find_all_matching("ADAMS").count
  end

  def test_district_repo_initialized_with_enrollment_repo
    dr = DistrictRepository.new

    assert_instance_of EnrollmentRepository, dr.enrollment_repo
  end

  def test_load_data_can_populate_enrollment_repo
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}

    assert_equal 0, dr.enrollment_repo.enrollments.count

    dr.load_data(data)

    assert_equal 181, dr.enrollment_repo.enrollments.count
  end

  def test_district_contains_enrollment_object
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)

    assert_instance_of Enrollment, dr.districts.values[0].enrollment
  end

  def test_enrollment_methods_available_through_district_repo
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)
    district = dr.find_by_name("ACADEMY 20")

    assert_equal 0.436,
      district.enrollment.kindergarten_participation_in_year(2010)
  end

  def test_load_data_can_send_multiple_files_to_enrollment_repo_for_loading
    dr = DistrictRepository.new
    dr.load_data({ :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
        }})
    enrollment = dr.enrollment_repo.enrollments.values[0]

    refute enrollment.kindergarten_participation.empty?
    refute enrollment.graduation_rates.empty?
  end

  def test_district_repo_intitializes_with_statewide_test_repo
    dr = DistrictRepository.new

    assert_instance_of StatewideTestRepository, dr.statewide_repo
  end

  def test_load_data_can_send_statewide_data_to_district_repo
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                  :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                  :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                }})
    statewide= dr.statewide_repo.find_by_name("academy 20")

    assert_equal "ACADEMY 20", statewide.name
  end

  def test_load_data_can_send_statewide_data_to_district_object
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                  :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                  :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                  :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                  :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                }})
    district = dr.find_by_name("academy 20")
    assert_instance_of StatewideTest, district.statewide_test
  end

def test_can_load_all_data_from_enrollment_and_statewide_test
  dr = DistrictRepository.new
  dr.load_data({:enrollment => {
                 :kindergarten => "./data/Kindergartners in full-day program.csv",
                 :high_school_graduation => "./data/High school graduation rates.csv",
                },
                :statewide_testing => {
                  :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                  :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                  :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                  :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                  :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                }
              })
    district = dr.find_by_name("academy 20")

    assert_instance_of Enrollment, district.enrollment
    assert_equal 0.489, district.enrollment.kindergarten_participation[2011]
    assert_instance_of StatewideTest, district.statewide_test
    assert_equal 0.819, district.statewide_test.third_grade[2011][:math]
  end

end
