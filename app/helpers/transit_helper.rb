require 'net/http'
require 'json'

module TransitHelper
  @@stopsbyroute = "http://realtime.mbta.com/developer/api/v2/stopsbyroute?api_key=wX9NwuHnZU2ToO7GmGR9uw&format=json&route="
  @@alertsbyroute = "http://realtime.mbta.com/developer/api/v2/alertsbyroute?api_key=wX9NwuHnZU2ToO7GmGR9uw&include_access_alerts=true&include_service_alerts=true&format=json&route="
  @@alert_levels = {
    'Minor' => 1,
    'Moderate' => 2,
    'Severe' => 3
  }

  def get_route_info(line)
    route = {
      'stops' => {},
      'alerts' => []
    }

    stops = make_query(@@stopsbyroute + line)
    alerts = make_query(@@alertsbyroute + line)
    route['name'] = alerts['route_name']

    delays = {}
    alerts['alerts'].each do |alert|
      if @@alert_levels.key?(alert['severity'])
        severity = @@alert_levels[alert['severity']]
      else
        severity = 0
      end

      title = alert['service_effect_text']
      header = alert['header_text']
      description = alert['description_text']

      route['alerts'].insert(0, {
        'title' => title.upcase, 
        'header' => header, 
        'description' => description, 
        'severity' => severity
      })

      if alert['effect_name'] == 'Delay'
        alert['affected_services']['services'].each do |service|
          id = service['stop_id']
          delays[id] = {
            'severity' => severity,
            'message' => header
          }
        end
      end
    end

    stops['direction'].each do |route_dir|
      direction = route_dir['direction_name']
      route['stops'][direction] = {}
      route_dir['stop'].each do |stop|
        id = stop['stop_id']
        name = stop['stop_name']

        if delays.key?(id)
          delay = delays[id]
        else
          delay = {
            'severity' => 0,
          }
        end

        route['stops'][direction][id] = {
          'name' => name, 
          'delay' => delay
        }
      end
    end

    return route
  end

  private
  def make_query(uri)
    url = URI.parse(uri)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    return JSON.parse(res.body)
  end
end
