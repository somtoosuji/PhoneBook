import Text "mo:base/Text";
import List "mo:base/List";
import Result "mo:base/Result";
actor {
  //variables

  //Type declarations
  type relationship = {
    #Friend;
    #Family;
  };

  type Contact = {
    firstName : Text;
    lastName : Text;
    phoneNumber: Text;
  };

  var contactList = List.nil<Contact>();
  //Update Queries
  public func createContact(contact : Contact) : async Result.Result<Text, Text> {

    contactList := List.push<Contact>(contact, contactList);
    switch (contactList) {
      case (?contactList) { return #ok("contact created") };
      case (null) { return #err("No contact List") };
    };
  };

  //Regular Queries

  public query func getContacts() : async Result.Result<List.List<Contact>, Text> {
    let size = List.size<Contact>(contactList);
    if (size == 0) {
      return #err "No contacts in storage!!";
    } else {
      return #ok contactList;
    };
  };


  public func delete(firstName : Text, lastName: Text) : async Result.Result<Text, Text> {
    let initialSize = List.size<Contact>(contactList);
    let remainingContacts = List.filter<Contact>(
      contactList,
      func (findContact : Contact) : Bool {
        not (firstName == findContact.firstName and lastName == findContact.lastName);
      },
    );
    contactList := remainingContacts;
    if (List.size<Contact>(contactList) < initialSize) {      
      return #ok("Success");
    } else {
      return #err("The contact was not found");      
    }
  };

};
