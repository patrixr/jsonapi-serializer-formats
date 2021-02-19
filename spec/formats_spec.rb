require 'spec_helper'

RSpec.describe JSONAPI::Formats do
  let(:movie) { Movie.fake }
  let(:serializer) { serializer_klass.new(movie, { params: { format: selected_formats }}) }
  let(:json) { serializer.serializable_hash }
  let(:data) { json[:data] }

  context 'Filtering attributes' do
    let(:serializer_klass) do
      Class.new do
        include JSONAPI::Serializer
        include JSONAPI::Formats
    
        set_type :movie
    
        attributes :name
    
        format :detailed do
          attribute :year

          format :review do
            attribute :rating_count
          end
        end

        format :review do
          attribute :rating
        end

        format :report do
          attribute :view_count
        end
      end
    end

    context 'with no selected format' do
      let(:selected_formats) { nil }

      it "includes the non-scoped attributes" do
        expect(data[:attributes][:name]).to eq(movie.name)
      end
  
      it "does not include attributes nested in a format" do
        expect(data[:attributes][:year]).to be_nil
      end
    end

    context 'with a selected format passed as param' do
      let(:selected_formats) { :detailed }

      it "includes the non-scoped attributes" do
        expect(data[:attributes][:name]).to eq(movie.name)
      end
  
      it "does not include attributes nested in the specified format" do
        expect(data[:attributes][:year]).to eq(movie.year)
      end
    end

    context 'with multiple formats passed as param' do
      let(:selected_formats) { [:detailed, :report] }

      it "includes the non-scoped attributes" do
        expect(data[:attributes][:name]).to eq(movie.name)
      end
  
      it "does not include attributes nested in each of the specified formats" do
        expect(data[:attributes][:year]).to eq(movie.year)
        expect(data[:attributes][:view_count]).to eq(movie.view_count)
      end
    end

    context 'of nested formats' do
      context 'with all the formats passed as param' do
        let(:selected_formats) { [:detailed, :review] }

        it "includes the attributes of the root format" do
          expect(data[:attributes][:year]).to eq(movie.year)
        end

        it "includes the attributes of the nested format" do
          expect(data[:attributes][:rating_count]).to eq(movie.rating_count)
        end
      end

      context 'with only nested format passed as param' do
        let(:selected_formats) { [:review] }

        it "includes the attributes of the format placed at the root" do
          expect(data[:attributes][:rating]).to eq(movie.rating)
        end

        it "does not include the attributes of the nested format" do
          expect(data[:attributes][:rating_count]).to be_nil
        end
      end
    end
  end
end
