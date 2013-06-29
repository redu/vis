# Todos precisam do type
# enrollment - user_id, subject_id, created_at
# remove_enrollment - user_id, subject_id, created_at

# subject_finalized - user_id, subject_id, created_at, updated_at
# remove_subject_finalized

# exercise_finalized - user_id, lecture_id, created_at
# remove_exercise_finalized - user_id, lecture_id, created_at

# status - user_id, status_id, created_at
# remove_status - user_id, status_id, created_at


var elements = db.hierarchy_notifications.aggregate({ $match : { type : "enrollment" } },
                                     { $group :
                                        { _id : { subject_id : "$subject_id",
                                                  user_id : "$user_id" },
                                          count : { $sum : 1 },
                                          object_ids : { $addToSet : "$_id" } } },
                                     { $match : { count : { $gte : 2 } } });


elements.result.forEach( function(e) {
  var qtt = db.hierarchy_notifications.find({ user_id : e._id.user_id, subject_id : e._id.subject_id, type : "remove_enrollment" }).count()
  e.object_ids.splice(0, (qtt+1));
  e.object_ids.forEach( function(oid) {
    db.hierarchy_notifications.remove({_id : oid }, 1);
  });
});

var elements = db.hierarchy_notifications.find({ subject_id : 4195, type : "enrollment" }, { user_id : 1 });

array = new Array
elements.forEach( function(e) {
  array.push(e.user_id);
});

var sorted_arr = array.sort();

var results = [];
for (var i = 0; i < array.length - 1; i++) {
    if (sorted_arr[i + 1] == sorted_arr[i]) {
        results.push(sorted_arr[i]);
    }
}
