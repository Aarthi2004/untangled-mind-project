
import Foundation
import UIKit



struct ServiceAPI {
    static let caretakerUserId = UserDefaults.standard.string(forKey: "UserId") ?? ""
    static let baseUrl = "http://localhost/medproject/"
    static let loginUrl = baseUrl + "Doctor_login.php?"
    static let CaretakerloginUrl = baseUrl + "Caretaker_login.php?"
    static let Add_CaretakerUrl = baseUrl + "Add_Caretakers.php?"
    static let Caretakers_listUrl = baseUrl + "Caretakers_list.php?"
    static let Caretaker_detailsUrl = baseUrl + "Caretaker_details.php?"
    static let update_ct_details_Url = baseUrl + "update_ct_details.php"
    static let add_Questionarie_Url = baseUrl + "add_Questionarie.php"
    static let post_questionaries_Url = baseUrl + "post_questionaries.php"
    static let post_ans_Url = baseUrl + "post_ans.php"
    static let topic_qns_Url = baseUrl + "topic_qns.php"
    static let topic_ans_Url = baseUrl + "topic_ans.php"
    static let get_video_Url = baseUrl + "get_video.php"
    static let Doctor_profile_Url = baseUrl + "Doctor_profile.php"
    static let update_dc_profile_Url = baseUrl + "update_dc_profile.php"
    static let signupUrl = baseUrl + "signup.php"
    static let dateUrl = baseUrl + "date.php"
    static let get_ansUrl = baseUrl + "get_ans.php"
    static let questionarie_scoreUrl = baseUrl + "questionarie_score.php"
    static let topic_listUrl = baseUrl + "topic_list.php"
    static let patient_profileUrl = baseUrl + "patient_profile.php"
    static let edit_ctdetailsUrl = baseUrl + "edit_ctdetails.php"
    static let getmotivationimagesUrl = baseUrl + "getmotivationimages.php"
    static let getsubtopicUrl = baseUrl + "getsubtopic.php"
    static let videoQuestionaryUrl = baseUrl + "videoquestions.php"
    static let topicAnswerUrl = baseUrl+"topic_ans.php"
    static let edit_topiclistUrl = baseUrl + "edit_topiclist.php"
    static let edit_subtopicslistUrl = baseUrl + "edit_subtopicslist.php"
    static let edit_topicquesUrl = baseUrl + "edit_topicques.php"
    static let searchBarUrl = baseUrl + "search.php"
    static let doctor_nameUrl = baseUrl + "doctor_name.php"
    static let topicdate_listUrl = baseUrl + "topicdate_list.php"
    static let gettopicansUrl = baseUrl + "gettopicans.php"
    static let add_suggestionsUrl = baseUrl + "add_suggestions.php"
    static let get_suggestionUrl = baseUrl + "get_suggestion.php"
    static let searchUrl = baseUrl + "search.php"
    static let updatevideoUrl = baseUrl + "updatevideo.php"
    static let addtopicUrl = baseUrl + "addtopic.php"
    static let addtopicquestionsUrl = baseUrl + "addtopicquestions.php"
    static let d_passwordUrl = baseUrl + "d_password.php"
    static let caretaker_nameUrl = baseUrl + "caretaker_name.php"
    static let doctorphoneUrl = baseUrl + "doctorphone.php"
    static let adminloginUrl = baseUrl + "adminlogin.php"
    static let Add_DoctorUrl = baseUrl + "Add_Doctor.php"
    static let dsearchUrl = baseUrl + "dsearch.php"
    static let doctorslistUrl = baseUrl + "doctorslist.php"
    static let doctordetailsUrl = baseUrl + "doctordetails.php"
    static let editdoctordetailsUrl = baseUrl + "editdoctordetails.php"
    static let adminprofileUrl = baseUrl + "adminprofile.php"
    static let editaminprofileUrl = baseUrl + "editaminprofile.php"
    
 
    
}

class Constants: NSObject {
    static var answerData: NSArray = []
}
