# soql2list
Lightning Component for driving a record list from a soql query

Watch the [app/code walkthrough video](https://www.youtube.com/watch?v=x827I7UUQ3I)

###Contents:
oraComponent : an extensible component consisting of helpers that connect to a generic apex class (ora) for query/describe (more methods to come soon)

RawSoqlList : displays a list of records based on a soql query set up as an attribute.  Includes design asset to allow soql entry through App Builder.  Also includes parameterized behavior selection (nothing, various navigation options, event firing)

AllFieldDisplayer : iterates through a record, across all fields provided, and optionally uses describe information to add friendly names via the field label.

recordSelectedEvent : an event fired by AllFieldDisplayer if event is the selected behavior

dynamic recordView : a wrapper for force:recordView to allow it to respond to the recordSelectedEvent, dynamically reloading itself to the new recordId.