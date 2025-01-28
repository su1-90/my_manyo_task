class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  

  # GET /tasks or /tasks.json
  def index
    if current_user
      @tasks = current_user.tasks

      if params[:search].present?
        if params[:search][:title].present? && params[:search][:status].present?
          @tasks = @tasks.search_by_title_and_status(params[:search][:title], params[:search][:status])
        elsif params[:search][:title].present?
          @tasks = @tasks.search_by_title(params[:search][:title])
        elsif params[:search][:status].present?
          @tasks = @tasks.search_by_status(params[:search][:status])
        end
      end

      if params[:sort_deadline_on]
        @tasks = @tasks.sorted_by_deadline
      elsif params[:sort_priority]
        @tasks = @tasks.sorted_by_priority
      else
        @tasks = @tasks.sorted_by_creation
      end

      @tasks = @tasks.page(params[:page])
      
    else
      flash[:alert] = 'ログインしてください'
      redirect_to new_session_path
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new(priority: nil, status: nil)
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    # @task = current_user.tasks.build(task_params)
    @task = current_user.tasks.build(task_params) if current_user.present?
    unless @task
      flash[:alert] = 'ログインしてください'
      redirect_to new_session_path
      return
    end


    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: t('flash.tasks.create') }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: t('flash.tasks.update') }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t('flash.tasks.destroy') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
    end

    def correct_user
      @task = current_user.tasks.find_by(id: params[:id])
      unless @task
        flash[:alert] = 'アクセス権限がありません'
        redirect_to tasks_path
      end
    end
end