require 'spec_helper'
require_relative '../../db/seeds_lib'
require_relative '../../db/unseeds'

RSpec.describe 'import/export round-trip' do
  it 'Exporting produces the same file as was imported' do
    empty_unparsed_yaml = file_fixture('empty.yml').read
    full_unparsed_yaml = file_fixture('full.yml').read

    empty_parsed_yaml = YAML.safe_load(empty_unparsed_yaml)
    full_parsed_yaml = YAML.safe_load(full_unparsed_yaml)

    original_yaml = fetch_records

    # Round-trip for empty.yml
    replace_records(empty_parsed_yaml)
    expect(fetch_records.to_yaml).to eq(empty_unparsed_yaml)

    # Round-trip for full.yml
    replace_records(full_parsed_yaml)
    expect(fetch_records.to_yaml).to eq(full_unparsed_yaml)

    # Restore original database so that this test doesn't interfere with the
    # others
    replace_records(original_yaml)
  end
end
