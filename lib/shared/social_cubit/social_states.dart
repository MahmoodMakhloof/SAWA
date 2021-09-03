abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class ChangeBotNavBarState extends SocialStates {
  final int index;

  ChangeBotNavBarState(this.index);
}

class ChangeScreensState extends SocialStates {
  final int index;

  ChangeScreensState(this.index);
}

class UserLoadingState extends SocialStates {}

class UserSuccessState extends SocialStates {}

class UserErrorState extends SocialStates {
  final String error;

  UserErrorState(this.error);
}

class ProfileImagePickedSuccessState extends SocialStates {}

class ProfileImagePickedErrorState extends SocialStates {}

class CoverImagePickedSuccessState extends SocialStates {}

class CoverImagePickedErrorState extends SocialStates {}

class ProfileImageUploadSuccessState extends SocialStates {}

class ProfileImageUploadErrorState extends SocialStates {}

class CoverImageUploadSuccessState extends SocialStates {}

class CoverImageUploadErrorState extends SocialStates {}

class ProfileImageUpdateSuccessState extends SocialStates {}

class ProfileImageUpdateErrorState extends SocialStates {}

class CoverImageUpdateSuccessState extends SocialStates {}

class CoverImageUpdateErrorState extends SocialStates {}

class BioUpdateSuccessState extends SocialStates {}

class BioUpdateErrorState extends SocialStates {}

class UpdateFinishedState extends SocialStates {}

//post
class PostImagePickedSuccessState extends SocialStates {}

class PostImagePickedErrorState extends SocialStates {}

class PostImageUploadLoadingState extends SocialStates {}

class PostImageUploadSuccessState extends SocialStates {}

class PostImageUploadErrorState extends SocialStates {}

class RemoveImageOfThePostState extends SocialStates {}

class CreatePostSuccessState extends SocialStates {}

class CreatePostErrorState extends SocialStates {}

class GetPostSuccessState extends SocialStates {}

class GetPostErrorState extends SocialStates {}

class GetMyPostSuccessState extends SocialStates {}

class GetMyPostErrorState extends SocialStates {}

class GetPersonPostSuccessState extends SocialStates {}

class GetPersonPostErrorState extends SocialStates {}



class GetProfileImageFromUidSuccessState extends SocialStates {}

class GetProfileImageFromUidErrorState extends SocialStates {}

// likes
class LikeSuccessState extends SocialStates {}

class LikeErrorState extends SocialStates {}

// dislike
class DisLikeSuccessState extends SocialStates {}

class DisLikeErrorState extends SocialStates {}

class GetLikeSuccessState extends SocialStates {}

class GetLikeErrorState extends SocialStates {}

class GetAllUsersSuccessState extends SocialStates {}

class GetAllUsersErrorState extends SocialStates {}

// chat
class SendMessageSuccessState extends SocialStates {}

class SendMessageErrorState extends SocialStates {}

class GetMessageSuccessState extends SocialStates {}

class GetMessageLoadingState extends SocialStates {}


// comments

class SendCommentSuccessState extends SocialStates {}

class SendCommentErrorState extends SocialStates {}

class GetCommentsSuccessState extends SocialStates {}

class GetCommentsNumbersSuccessState extends SocialStates {}
class GetCommentsNumbersErrorState extends SocialStates {}


class GetChatsSuccessState extends SocialStates {}
class GetChatsErrorState extends SocialStates {}

// notification
class SendNotificationsSuccessState extends SocialStates {}
class SendNotificationsErrorState extends SocialStates {}

class GetNotificationsSuccessState extends SocialStates {}
class GetNotificationsErrorState extends SocialStates {}

//recent messages
class SetRecentMessageSuccessState extends SocialStates {}
class SetRecentMessageErrorState extends SocialStates {}
class GetRecentMessagesSuccessState extends SocialStates {}

class DeletePostSuccessState extends SocialStates {}
class DeleteChatSuccessState extends SocialStates {}