require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class AuthrepApplicationKeysTest < Test::Unit::TestCase
  include TestHelpers::AuthorizeAssertions
  include TestHelpers::Fixtures
  include TestHelpers::Integration

  def setup
    Storage.instance(true).flushdb

    setup_provider_fixtures

    @application = Application.save(:service_id => @service.id,
                                    :id         => next_id,
                                    :state      => :active,
                                    :plan_id    => @plan_id,
                                    :plan_name  => @plan_name)
  end

  test 'succeeds if no application key is defined nor passed' do
    get '/transactions/authrep.xml', :provider_key => @provider_key,
                                     :app_id       => @application.id

    assert_authorized
  end

  test 'succeeds if one application key is defined and the same one is passed' do
    application_key = @application.create_key

    get '/transactions/authrep.xml', :provider_key => @provider_key,
                                     :app_id       => @application.id,
                                     :app_key      => application_key

    assert_authorized
  end

  test 'succeeds if multiple application keys are defined and one of them is passed' do
    application_key_one = @application.create_key
    application_key_two = @application.create_key

    get '/transactions/authrep.xml', :provider_key => @provider_key,
                                     :app_id       => @application.id,
                                     :app_key      => application_key_one

    assert_authorized
  end

  test 'does not authorize if application key is defined but not passed' do
    @application.create_key

    get '/transactions/authrep.xml', :provider_key => @provider_key,
                                     :app_id       => @application.id

    assert_not_authorized 'application key is missing'
  end

  test 'does not authorize if application key is defined but wrong one is passed' do
    @application.create_key('foo')

    get '/transactions/authrep.xml', :provider_key => @provider_key,
                                     :app_id       => @application.id,
                                       :app_key      => 'bar'

    assert_not_authorized 'application key "bar" is invalid'
  end
end
