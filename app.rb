# routing.rb
require 'rubygems'
require 'sinatra'
require 'json'
require 'daybreak'

#Home page
get '/' do
  #Return index.html
  File.read(File.join('public', 'index.html'))
end

#Error 404
get '/error404/?' do
  #Return error404.html
  status 404
  File.read(File.join('public', '404.html'))
end

#List all contacts
get '/contacts/?' do
  db = Daybreak::DB.new "contacts.db"  #Define Db
  db.load  #load Database file
  db_hash = Hash.new  #Create new hash to load in contacts from db
  db.each { |id,contact| db_hash[id] = contact } #Iterate through entries
  db.close #Make sure to close
  status 200
  db_hash.to_json #Convert to JSON
end

#Get contact by id
get '/contacts/:id/?' do
  db = Daybreak::DB.new "contacts.db"
  db.load
  db_hash = Hash.new
  db.each do |id,contact| #Iterate through and add if present
    if id == params[:id]
      db_hash[id] = contact
    end
  end
  db.close
  if db_hash.length < 1
    redirect to('/error404')
  else
    status 200
    db_hash.to_json
  end
end

#Search by surname
get '/contacts/search/:surname/?' do
  db = Daybreak::DB.new "contacts.db"
  db.load
  db_hash = Hash.new
  db.each do |id,contact| #Iterate through and add if present
    c = contact_from_hash(contact) #Create contact from hash
    if c.lname.downcase == params[:surname].downcase
      db_hash[id] = contact
    end
  end

  db.close

  if db_hash.length < 1
    redirect to('/error404')
  else
    status 200
    db_hash.to_json
  end
end

#New contact
post '/contacts/?' do
  begin
    json_hash = JSON.parse(request.body.read)
    if (json_hash.has_key? 'fname')&& (json_hash.has_key? 'lname') && (json_hash.has_key? 'num')
      #Get next available id
      id = getNextId

      db = Daybreak::DB.new "contacts.db"
      #Create and contact and add to db
      contact = Contact.new(json_hash['fname'], json_hash['lname'], json_hash['num'], json_hash['addr'])
      db.set! id, contact.to_hash
      db.flush
      db.close
      status 201
    else
      status 400
    end
  rescue #Catch Faulty JSON here
    status 400
  end
end

#Update by ID
put '/contacts/:id/?' do
  id = params[:id]
  db = Daybreak::DB.new "contacts.db"

  begin
    json_hash = JSON.parse(request.body.read)

    if db.keys.include? id
      #Contact there, update.
      if (json_hash.has_key? 'fname') && (json_hash.has_key? 'lname') && (json_hash.has_key? 'num')
        #Create and contact and add to db
        contact = Contact.new(json_hash['fname'], json_hash['lname'], json_hash['num'], json_hash['addr'])
        db.set! id, contact.to_hash
        status 204
      else
        status 400
      end
    else
      #Contact does not exist
      db.flush
      db.close
      redirect to('/error404')
    end
  rescue #Catch Faulty JSON here
    status 400
  end
  db.flush
  db.close
end

#Remove by ID
delete '/contacts/:id/?' do
  db = Daybreak::DB.new "contacts.db"

  if db.has_key?(params[:id])
    db.delete!(params[:id])
    status 204
    db.flush
    db.close
  else
    db.flush
    db.close
    redirect to('/error404')
  end
end

#Given a hash return a new contact
def contact_from_hash(contact)
  return Contact.new(contact['fname'], contact['lname'], contact['num'], contact['addr'])
end

#Get next available id from contacts
def getNextId
  db = Daybreak::DB.new "contacts.db"

  db.load
  db_hash = Hash.new

  tempId = 0

  db.each do |id,contact| #Iterate through and add if present
      if Integer(id) > tempId
        tempId = Integer(id) + 1
      elsif Integer(id) == tempId
        tempId += 1
      end
  end

  db.close
  return tempId
end

#Contact class
class Contact
  attr_accessor :fname,:lname,:num,:addr

  def initialize(fname, lname, num, addr)
    @fname = fname
    @lname = lname
    @num   = num
    @addr  = addr
  end

  #Turn to hash
  def to_hash
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
end
