require "google-cloud-firestore"

firestore = Google::Cloud::Firestore.new(project_id: "test-project")

firestore.doc("users/test-user").set({ user_name: "test", url: "https://example.com/" })
firestore.doc("users/test-user").update({ user_name: "test", url: "https://example.com/new" })
firestore.doc("users/test-user").get.data
firestore.doc("users/test-user").get.exists?
firestore.doc("users/test-user").delete
