require_relative 'headcount_calculator'

class EconomicProfile
  attr_reader :median_household_income,
              :children_in_poverty,
              :free_or_reduced_price_lunch,
              :title_i,
              :name

  def initialize(economic_info)
    @median_household_income = set_empty_hash_if_nil(
          economic_info[:median_household_income])
    @children_in_poverty = set_empty_hash_if_nil(
          economic_info[:children_in_poverty])
    @free_or_reduced_price_lunch = set_empty_hash_if_nil(
          economic_info[:free_or_reduced_price_lunch])
    @title_i = set_empty_hash_if_nil(
          economic_info[:title_i])
    @name = economic_info[:name]
  end

  def set_empty_hash_if_nil(info)
    info.nil? ? {} : info
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError if free_or_reduced_price_lunch[year].nil?
    HeadcountCalculator.truncate(free_or_reduced_price_lunch[year][:percentage])
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError if free_or_reduced_price_lunch[year].nil?
    free_or_reduced_price_lunch[year][:total]
  end


end