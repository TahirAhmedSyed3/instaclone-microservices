package com.instaclone.userservice;

import jakarta.persistence.*;

@Entity
@Table(name = "users") // ✅ FIX: avoid reserved keyword
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String displayName;
    private String bio;

    public User() {}

    public User(String username, String displayName, String bio) {
        this.username = username;
        this.displayName = displayName;
        this.bio = bio;
    }

    public Long getId() { return id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
}