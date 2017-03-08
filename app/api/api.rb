class API < Grape::API
  prefix 'api'
  version 'v1', using: :path
  mount Employee::Data
  mount Tags::List

end