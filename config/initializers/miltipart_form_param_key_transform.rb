# # # File: config/initializers/json_param_key_transform.rb
# # # Transform JSON request param keys from JSON-conventional camelCase to
# # # Rails-conventional snake_case:
# ActionDispatch::Request.parameter_parsers[:multipart_form] = -> (raw_post) {
#     parts={}

#     reader = MultipartParser::Reader.new(MultipartParser::Reader::extract_boundary_value(request.headers['CONTENT_TYPE']))

#     reader.on_part do |part|
#       pn = part.name.to_sym
#       part.on_data do |partial_data|
#         if parts[pn].nil?
#           parts[pn] = partial_data
#         else
#           parts[pn] = [parts[pn]] unless parts[pn].kind_of?(Array)
#           parts[pn] << partial_data
#         end
#       end
#     end

#     reader.write request.raw_post
#     reader.ended? or raise Exception, 'truncated multipart message'

#     parts
# }