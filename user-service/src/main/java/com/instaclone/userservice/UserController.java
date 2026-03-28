package com.instaclone.userservice;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserRepository repository;

    public UserController(UserRepository repository) {
        this.repository = repository;
    }

    @PostMapping
    public User createUser(@RequestBody User user){
        return repository.save(user);
    }

    @GetMapping
    public List<User> getAllUsers(){
        return repository.findAll();
    }

    @PutMapping("/{id}")
    public User updateUser(@PathVariable Long id, @RequestBody User updatedUser) {
        return repository.findById(id)
                .map(user -> {
                    user.setDisplayName(updatedUser.getDisplayName());
                    user.setBio(updatedUser.getBio());
                    return repository.save(user);
                })
                .orElseThrow(() -> new RuntimeException("User not found with id " + id));
    }
}