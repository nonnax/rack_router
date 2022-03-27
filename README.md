#  rack-roruter
methods: 

R creates controllers and collects the classes route queries
controller directory path: '../apps/'

responses are handled by the matching methods in the controller
  
ex. response 

when  env['PATH_INFO']=='/url' && env['REQUEST_METHOD']=='GET'
run the Controller.get method

params are env['QUERY_STRING']

erb renders templates located in the 
views directory path: '../views/'

sample code:

```ruby
  class Controller < R '/url'

    def self.get(params)
      name=params['name'] || 'world'
      "Hello #{name}"
    end

    def self.post(params)
      "posting... with #{params}"
      erb :view
    end

  end

```
