require 'spec_helper'

describe Lita::Handlers::AwsIam, lita_handler: true do
  it { is_expected.to route_command('iam').to(:handle_iam) }

  it 'returns the VRT Mess menu' do
    send_command('iam')
    expect(replies.first).to start_with('iam')
  end
end
