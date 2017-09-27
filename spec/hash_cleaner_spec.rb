require 'spec_helper'
require 'hashcleaner'
require 'yaml'

describe 'Hash Cleaner' do
  let(:yaml_str) {
    <<EoJ
    {
      ".not-a-secret": {
        "credential": false,
        "configurable": true,
        "value": "apps.example.com"
      },
      ".not-configurable": {
        "credential": false,
        "configurable": false,
        "value": "generated value"
      },
      ".secret.updated": {
        "credential": true,
        "configurable": true,
        "value": {
          "super_secret": "updated"
        }
      },
      ".secret.redacted": {
        "credential": true,
        "configurable": true,
        "value": {
          "somefield": "somevalue",
          "secret": "***"
        }
      }
    }
EoJ
  }

  let(:processed_secret) { HashCleaner.clean(YAML.load(yaml_str)) }

  it 'doesnt touch non-credentials fields' do
    expect(processed_secret).to have_key(".not-a-secret")
  end

  context 'objects that contain credentials' do
    it 'dont touch if the secret is not redacted' do
      expect(processed_secret).to have_key(".secret.updated")
    end
    it 'removes if the secret is redacted' do
      expect(processed_secret).not_to have_key(".secret.redacted")
    end
  end

  context 'objects that are not configurable' do
    it 'removes it from the result' do
      expect(processed_secret).not_to have_key(".not-configurable")
    end
  end
end
