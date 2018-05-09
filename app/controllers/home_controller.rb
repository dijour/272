class HomeController < ApplicationController
  def index
    @week_money = Camp.joins(:registrations).group_by_week(:start_date).pluck("camps.start_date, sum(cost) as profits")
    @month_money = Camp.joins(:registrations).group_by_month(:start_date).pluck("date(camps.start_date), sum(cost) as profits")
    @year_money = Camp.joins(:registrations).group_by_year(:start_date).pluck("date(camps.start_date), sum(cost) as profits")
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
end