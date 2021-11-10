file 'tmp/apis_s3_2006-03-01_api-2.json' do
  sh "curl -o tmp/apis_s3_2006-03-01_api-2.json https://raw.githubusercontent.com/aws/aws-sdk-ruby/version-3/apis/s3/2006-03-01/api-2.json"
end

file 'gems/aws-sdk-s3/1/2006-03-01_api-2.rbs' => ['tmp/apis_s3_2006-03-01_api-2.json', 'aws_client_types_generator.rb'] do
  ruby "aws_client_types_generator.rb tmp/apis_s3_2006-03-01_api-2.json > gems/aws-sdk-s3/1/2006-03-01_api-2.rbs"
end

task :aws => [
  'gems/aws-sdk-s3/1/2006-03-01_api-2.rbs'
]
