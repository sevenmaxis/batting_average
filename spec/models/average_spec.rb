require 'rails_helper'
require 'csv'

RSpec.describe Average, type: :model do
  let(:build_averages) { 2.times.map { build(:average) } }

  describe "Checks database restrictions" do
    it 'does not create with same id' do
      expect {
        build_averages.each { |average| average.id = "PS1" }.map(&:save!)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe 'Using indexs' do
    before(:each) do
      build_averages.map(&:save!)

      # NOTE: Force to use index for small amount of records
      ActiveRecord::Base.connection.execute('SET enable_seqscan = OFF')
    end

    it 'makes sure using index for year' do
      analyze = Average.where(year: '1900').analyze

      expect(analyze).to include('Bitmap Heap Scan on averages')
    end

    it 'makes sure using index for teams' do
      analyze = Average.where("teams @> ARRAY[?]::varchar[]", Average.last.teams).analyze

      expect(analyze).to include('Bitmap Heap Scan on averages')
    end

    it 'makes sure using index for year and teams' do
      analyze = Average.where(year: '1891').where("teams @> ARRAY[?]::varchar[]", Average.last.teams).analyze

      expect(analyze).to include('Bitmap Heap Scan on averages')
    end
  end
end
