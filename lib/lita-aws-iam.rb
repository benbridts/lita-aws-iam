require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', 'locales', '*.yml'), __FILE__
)]

require 'lita/handlers/awshelpers'
require 'lita/handlers/aws_iam'
require 'lita/handlers/lita_helper'

Lita::Handlers::AwsIam.template_root File.expand_path(
  File.join('..', '..', 'templates'),
  __FILE__
)
