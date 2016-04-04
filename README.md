# Simple Ruby Phonebook

A Simple phonebook HTTP/RESTful application.

Created with Ruby, [Sinatra](http://www.sinatrarb.com/) (For http routing) and [Daybreak](http://propublica.github.io/daybreak/) (For simple Key/Value storage).

Functionality:
- List all entries in the phone book.
- Create a new entry to the phone book.
- Remove an existing entry in the phone book.
- Update an existing entry in the phone book.
- Search for entries in the phone book by surname.

## Installation

Requirements: Ruby.

1. Ensure Ruby along with RubyGems is installed on your system
2. Run `gem install sinatra`
3. Run `gem install json`
  - Note if this fails you may need to install ruby-dev: `sudo yum install ruby-devel` / `sudo apt-get install ruby-dev`
4. Run `gem install daybreak`
5. Run `ruby app.rb` to start the application

## Usage

Navigate to `http://localhost:4567/` after running the application.

The phonebook application is a simple RESTful web service.

It accepts GET/PUT/POST and DELETE HTTP requests in JSON format.

### GET `http://localhost:4567/contacts/`
  Retrieves all contacts in JSON format.
  ```
  {  
     "0":{  
        "fname":"John",
        "lname":"Smith",
        "num":"07728372667",
        "addr":"11 Made up road"
     },
     "1":{  
        "fname":"Jimmy",
        "lname":"James",
        "num":"01202927262",
        "addr":"12 North Park Road"
     },
     .....
  }

  ```
### GET `http://localhost:4567/contacts/:id/`
  Retrieves a single contact by its id number in JSON format.
  ```
  {  
     "1":{  
        "fname":"Jimmy",
        "lname":"James",
        "num":"01202927262",
        "addr":"12 North Park Road"
     }
  }
  ```
### GET `http://localhost:4567/contacts/search/:surname/`
  Searches contacts based on their surname. I.e. `http://localhost:4567/contacts/search/smith/` will return:
  ```
  {  
     "4":{  
        "fname":"Jennifer",
        "lname":"Smith",
        "num":"102903874756",
        "addr":"45 Smith Road"
     }
  }
  ```
### PUT `http://localhost:4567/contacts/:id/`
  Updates a current contact by its id number. Below is an example on the required JSON.
  ```
  {
      "fname":"Jimmy",
      "lname":"James",
      "num":"01202558996",
      "addr":"12 North Park Road"
  }
  ```
  Note, the 'addr' field is optional.
### POST `http://localhost:4567/contacts/`
  Similar to PUT but creates a new contact rather than updating.
  ```
  {
      "fname":"Laura",
      "lname":"Smith",
      "num":"02356987456",
      "addr": "45 Smith Road"
  }
  ```

### DELETE `http://localhost:4567/contacts/:id/`
  Deletes a contact by its id number

## History

 - 4th April 2016: Initial deployment.
