module ApplicationHelper
  def camp_instructor_id_for(camp, instructor)
    ci = CampInstructor.where(camp_id: camp.id, instructor_id: instructor).first
    return ci.id unless ci.nil?
  end
  
  def weekly_profit
    profit = 0
    for camp in Camp.active
      if camp.start_date <= Date.today && camp.end_date >= Date.today
        profit += (camp.registrations.size*camp.cost)
      end
    end
    return number_to_currency(profit, :unit => "$")
  end
  
end
