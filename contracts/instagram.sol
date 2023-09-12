pragma solidity ^0.8.0;

contract SocialMedia {
    struct Post {
        uint id;
        address author;
        string content;
        string imageUrl;
        uint likes;
        Comment[] comments;
    }

    struct Comment {
        address author;
        string content;
    }

    struct Profile {
        string username;
        string bio;
        string profileImageUrl;
    }

    mapping (address => Profile) public profiles;
    mapping (uint => Post) public posts;
    uint public postCount;

    event PostCreated(uint postId, address author, string content, string imageUrl);
    event PostLiked(uint postId, address liker);
    event CommentAdded(uint postId, address commenter, string content);

    function createPost(string memory _content, string memory _imageUrl) public {
        require(bytes(_content).length > 0, "Content cannot be empty");

        postCount++;
        posts[postCount] = Post(postCount, msg.sender, _content, _imageUrl, 0, new Comment[](0));

        emit PostCreated(postCount, msg.sender, _content, _imageUrl);
    }

    function likePost(uint _postId) public {
        require(_postId > 0 && _postId <= postCount, "Invalid post ID");

        Post storage post = posts[_postId];
        post.likes++;

        emit PostLiked(_postId, msg.sender);
    }

    function addComment(uint _postId, string memory _content) public {
        require(_postId > 0 && _postId <= postCount, "Invalid post ID");
        require(bytes(_content).length > 0, "Comment content cannot be empty");

        Post storage post = posts[_postId];
        post.comments.push(Comment(msg.sender, _content));

        emit CommentAdded(_postId, msg.sender, _content);
    }

    function updateProfile(string memory _username, string memory _bio, string memory _profileImageUrl) public {
        require(bytes(_username).length > 0, "Username cannot be empty");

        Profile storage profile = profiles[msg.sender];
        profile.username = _username;
        profile.bio = _bio;
        profile.profileImageUrl = _profileImageUrl;
    }
}