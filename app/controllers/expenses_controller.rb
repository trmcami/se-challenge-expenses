class ExpensesController < ApplicationController
  before_filter :check_file_format, only: :create
  before_filter :clear_session, only: :create

  def index
    expenses_ids = session['uploaded_expenses']
    @expenses = Expense.where(id: expenses_ids).total_expenses_by_month
  end

  def new
  end

  def create
    importer = ExpensesImporter.new(file_content: params['expenses_file'].read)
    uploaded_expenses = importer.import

    if uploaded_expenses.present?
      session['uploaded_expenses'] = uploaded_expenses
      redirect_to action: :index
    else
      flash[:error] = "We encountered a problem while trying to import the data you provided. If the problem persists, please contact some@one.com"
      redirect_to action: :new
    end
  end

  private

  def check_file_format
    unless params['expenses_file'].present? && ExpensesImporter.allowed_format?(params['expenses_file'].original_filename)
      flash[:error] = "The formats accepted are: #{ExpensesImporter::ACCEPTED_FORMATS.join(',')}"
      redirect_to action: :new
    end
  end

  def clear_session
    session['uploaded_expenses'] = nil
  end
end
