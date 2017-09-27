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
      ".optional": {
        "credential": false,
        "configurable": true,
        "optional": true,
        "value": null
      },
      ".not-optional": {
        "credential": false,
        "configurable": true,
        "optional": false,
        "value": null
      },
      ".not-optional-but-set": {
        "credential": false,
        "configurable": true,
        "optional": false,
        "value": "123"
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
      },
      ".collection": {
        "type": "collection",
        "configurable": true,
        "credential": false,
        "optional": true,
        "value": [
          {
            "guid": {
              "type": "uuid",
              "configurable": false,
              "credential": false,
              "value": "some-guid",
              "optional": false
            },
            "href": {
              "type": "string",
              "configurable": false,
              "credential": false,
              "value": "some-url",
              "optional": false
            }
          }
        ]
      },
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

  context 'optional fields' do
    it 'removes the non-optional fields with null values' do
      expect(processed_secret).not_to have_key(".not-optional")
    end

    it 'dont touch the required fields with non-null values' do
      expect(processed_secret).to have_key(".not-optional-but-set")
    end

    it 'dont touch the optional fields with null values' do
      expect(processed_secret).to have_key(".optional")
    end
  end

  context 'collections' do
    it 'flats out the value array' do
      expect(processed_secret).to have_key(".collection")
      collection = processed_secret['.collection']
      expect(collection['value'].first['guid']).to eq("some-guid")
      expect(collection['value'].first['href']).to eq("some-url")
    end
  end
end
