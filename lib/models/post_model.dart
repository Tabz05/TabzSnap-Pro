class PostModel{
    
    final String postText;
    final String postImageUri;
    final String postVideoUri;
    final String owner;

    var blockedBy = [];

    final String postId;

    PostModel(this.postText,this.postImageUri,this.postVideoUri,this.owner,this.blockedBy,this.postId);

}