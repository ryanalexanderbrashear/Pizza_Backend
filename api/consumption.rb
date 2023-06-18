require 'sequel'

class Consumption < Grape::API
  version 'v1'
  format :json

  # Use sequel to connect to the needed databases
  consumption = DB[:consumption]
  pizza = DB[:pizzas]
  people = DB[:people]

  # Endpoint to get all consumption records
  get '/consumption' do
    consumption_data = people.join(consumption, person_id: :id)
    consumption_data = pizza.join(consumption_data, pizza_id: :id)
    consumption_data.order(:date).all
  end

  # Endpoint to get all consumption records by meat type
  params do
    requires :meat_type, type: String, desc: "Meat type on the pizza"
  end
  get '/consumptionByMeat' do
    consumption_data = people.join(consumption, person_id: :id)
    consumption_data = pizza.join(consumption_data, pizza_id: :id)
    consumption_data = consumption_data.where(:meat_type => params[:meat_type])
    consumption_data.order(:date).all
  end

  # Endpoint to get all consumption record streaks where more pizza was consumed the next day than the previous
  get '/consumptionStreaks' do
    date_count = consumption.group_and_count(:date).order(:date)
    previousValue = date_count.first[:count]
    streaks = []
    newStreak = [date_count.first[:date]]
    date_count.map { |count|
      if (count[:count] > previousValue) 
        newStreak.push(count[:date])
      else
        if newStreak.length() > 1
          streaks.push(newStreak)
        end
        newStreak = [count[:date]]
      end
      previousValue = count[:count]
    }
    streaks
  end

  # Endpoint to get all consumption records for which day the most pizzas were consumed in each month
  # TODO: Figure out a way to make this cleaner. Currently doesn't check to see if dates with the same month are in the same year, and requires checking each month, even if there are no records for that month
  get '/consumptionByMonth' do
    months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    date_count = consumption.group_and_count(:date).order(:date)
    months.map { |month|
      date_count.filter(Sequel[:date].extract(:month) => month).order(Sequel.desc(:count)).first
    }
  end
end