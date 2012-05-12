class ContractsController < ApplicationController
	before_filter :authenticate_user!, :only => [:index, :show]
  before_filter :authenticate_admin!, :only => [:new, :create, :edit, :update, :destroy]
  def index
    @contracts = Contract.all
  end
  
  def show
    @contract = Contract.find(params[:id], :include => [:students, :companies, :contract_types])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @contract_type }
    end
  end
  
  def new
    @new = true
    @contract = Contract.new
    @students = Student.all    
    @companies = Company.all
    @contract_types = ContractType.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @contract }
    end
  end
  
  def edit
		@contract = Contract.find(params[:id], :include => [:students, :companies, :contract_types])
  end
  

 
  def create
  	
		@datedebut = Date.civil(params[:contract][:"date_debut(1i)"].to_i,
		params[:contract][:"date_debut(2i)"].to_i,
		params[:contract][:"date_debut(3i)"].to_i)
								
		@datefin = Date.civil(params[:contract][:"date_fin(1i)"].to_i,
		params[:contract][:"date_fin(2i)"].to_i,
		params[:contract][:"date_fin(3i)"].to_i)
	
		@company = Company.find(params[:contract][:companies])		
		@student = Student.find(params[:contract][:students])
		@contract_type = ContractType.find(params[:contract][:contract_types])
										
		@contract = Contract.new(	:date_debut => @datedebut,
															:date_fin => @datefin,
															:students => @student)
 
  	respond_to do |format|
    	if @contract.save
															
		#@contract.students = @student
		#@contract.companies = @company
		#@contract.contract_types = @contract_type
		
				#@contract.save
		
      	format.html  { redirect_to(@contract, :notice => 'Contract was successfully created.') }
      	format.json  { render :json => @contract, :status => :created, :location => @contract }
    	else
      	format.html  { render :action => "new" }
      	format.json  { render :json => @contract.errors, :status => :unprocessable_entity }
    	end
  	end
	end
	
  
  def update
  	@contract = Contract.find(params[:id]) 
  	respond_to do |format|
    	if @contract.update_attributes(params[:contract])
      	format.html  { redirect_to(@contract, :notice => 'Contract Type was successfully updated.') }
      	format.json  { head :no_content }
    	else
      	format.html  { render :action => "edit" }
      	format.json  { render :json => @contract.errors, :status => :unprocessable_entity }
    	end
  	end
	end
  
  def destroy
    Contract.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to contracts_url }
      format.json { head :ok }
    end
  end 
end
