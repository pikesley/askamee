require 'spec_helper'

describe QuestionController do
  describe "GET answer" do
    
    it "assigns quantities" do
      get :answer, :q => 'shipping 10 tonnes of stuff for 1000 kilometres'
      assigns(:quantities).map{|x| x.to_s}.should eql ['10.0 t', '1000.0 km']
    end

    it "assigns terms" do
      get :answer, :q => 'shipping 10 tonnes of stuff for 1000 kilometres'
      assigns(:terms).should eql ['shipping', 'stuff']
    end

    it "assigns categories" do
      get :answer, :q => 'shipping 10 tonnes of stuff for 1000 kilometres'
      assigns(:categories).should eql [ "Etching_and_CVD_cleaning_in_the_Electronics_Industry", 
                                        "DEFRA_freight_transport_methodology", 
                                        "Freight_transport_by_Greenhouse_Gas_Protocol" ]
    end

    it "assigns a thinking message" do
      get :answer, :q => 'shipping 10 tonnes of stuff for 1000 kilometres'
      assigns(:message).should_not be_blank
    end


  end

  describe "GET detail" do

    it "gets results with a single input quantity" do
      get :detailed_answer, :quantities => '100.0 km', :terms => 'truck', :category => 'Generic_van_transport'
      assigns(:amount).should_not be_nil
      assigns(:amount)[:value].should eql 27.18
      assigns(:more_info_url).should eql 'http://discover.amee.com/categories/Generic_van_transport/data/cng/up%20to%203.5%20tonnes/result/false/true/none/100.0;km/false/none/0/-1/0/true/false/false'
    end
    
    it "gets results with two input quantities" do
      get :detailed_answer, :quantities => '100.0 km,1.0 t', :terms => 'truck', :category => 'DEFRA_freight_transport_methodology'
      assigns(:amount).should_not be_nil
      assigns(:amount)[:value].should eql 80.7365279
      assigns(:more_info_url).should eql 'http://discover.amee.com/categories/DEFRA_freight_transport_methodology/data/van/petrol/1.305-1.74%20t/result/100.0;km/1.0;t'
    end

    it "gets results with IATA codes" do
      get :detailed_answer, :quantities => 'from:LHR,to:LAX', :terms => 'fly', :category => 'Great_Circle_flight_methodology'
      assigns(:amount).should_not be_nil
      assigns(:amount)[:value].should be_within(1e-9).of(1064.49102031516)
      assigns(:more_info_url).should eql 'http://discover.amee.com/categories/Great_Circle_flight_methodology/data/great%20circle%20route/result/LHR/LAX/false/1/-999/-999/-999/-999/none/average/1/1.9/false'
    end


  end


end