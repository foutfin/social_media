import { json } from "react-router-dom"

const BASE_URL = "http://127.0.0.1:3000/api"

const logIn = async (formData)=>{
    if(Object.keys(formData).length  == 0){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/user/login`,
            {   
                headers: {
                    "Content-type": "application/json",             
                },
                method: "POST",
                body: JSON.stringify(formData),
                
            })
        const json_body = await response.json()
        if(!response.ok ){
            return [false, json_body]
        }
        
        setToken(response.headers.get("Authorization"))
        return [true , json_body.msg]     
    }catch{
        return [false,{error:["Something Went Wrong"]}]
    }
    
}

const signUp = async (formData) =>{
    if(!formData){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/user/register`,
            {   
            method: "POST",
            body: formData,
            })
        const json_body = await response.json()
        console.log(json_body)

        if( !response.ok ){
            return [false, json_body]
        }
        return [true , json_body.msg]     
    }catch{
        return [false,{error:["Something Went Wrong"]}]
    }
}

const createPost = async (formData) =>{
    const token = getToken()
    if(!formData){
        return false
    }
    console.log(formData)
    try{
        const response = await fetch(`${BASE_URL}/post`,
            {   
            method: "POST",
            body: formData,
            headers: {
                "Authorization": `Bearer ${token}` 
            }
            })
        const json_body = await response.json()
        if(json_body.status != 200 ){
            return [false, json_body]
        }
        return [true , json_body.msg]     
    }catch{
        return [false,["Something Went Wrong"]]
    }
}

const followRequest = async (id) =>{
    console.log(id)
   const token = getToken()
   try{
        const response = await fetch(`${BASE_URL}/user/follow`,
            {   
            method: "POST",
            
            headers: {
                "Authorization": `Bearer ${token}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ 
                user_id: id
            }), 
            })
        const json_body = await response.json()
        if(json_body.status != 200 ){
            return [false, json_body]
        }
        return [true , json_body.msg]     
    }catch{
        return [false,["Something Went Wrong"]]
    }
}

const archivePost = async (post_id) =>{
   const token = getToken()
   try{
        const response = await fetch(`${BASE_URL}/post/archive`,
            {   
            method: "PUT",
            
            headers: {
                "Authorization": `Bearer ${token}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ 
                post_id: post_id
            }), 
            })
        const json_body = await response.json()
        if(json_body.status != 200 ){
            return [false, json_body.errors]
        }
        return [true , json_body.msg]     
    }catch{
        return [false,["Something Went Wrong"]]
    }
}

const editPost = async (post_id,caption,body) =>{
    const token = getToken()
    try{
         const response = await fetch(`${BASE_URL}/post`,
             {   
             method: "PUT",
             
             headers: {
                 "Authorization": `Bearer ${token}`,
                 "Content-Type": "application/json"
             },
             body: JSON.stringify({ 
                 post_id: post_id,
                 caption: caption,
                 body: body
             }), 
             })
         const json_body = await response.json()
         if(json_body.status != 200 ){
             return [false, json_body.errors]
         }
         return [true , json_body.msg]     
     }catch{
         return [false,["Something Went Wrong"]]
     }
 }

 const editUser = async (formdata) =>{
    const token = getToken()
    try{
         const response = await fetch(`${BASE_URL}/user`,
             {   
             method: "PUT",
             
             headers: {
                 "Authorization": `Bearer ${token}`,
             },
             body: formdata
             })
         const json_body = await response.json()
         if(!response.ok ){
             return [false, json_body]
         }
         return [true , json_body.msg]     
     }catch{
         return [false,["Something Went Wrong"]]
     }
 }

const deletePost = async (post_id) =>{
    const token = getToken()
    try{
         const response = await fetch(`${BASE_URL}/post`,
             {   
             method: "DELETE",
             
             headers: {
                 "Authorization": `Bearer ${token}`,
                 "Content-Type": "application/json"
             },
             body: JSON.stringify({ 
                 post_id: post_id
             }), 
             })
         const json_body = await response.json()
         if(json_body.status != 200 ){
             return [false, json_body.errors]
         }
         return [true , json_body.msg]     
     }catch{
         return [false,["Something Went Wrong"]]
     }
 }


 const deleteUser = async () =>{
    const token = getToken()
    try{
         const response = await fetch(`${BASE_URL}/user`,
             {   
             method: "DELETE",
             
             headers: {
                 "Authorization": `Bearer ${token}`,
             }
             })
         const json_body = await response.json()
         if(json_body.status != 200 ){
             return [false, json_body.errors]
         }
         return [true , json_body.msg]     
     }catch{
         return [false,["Something Went Wrong"]]
     }
 }

 const downloadData = async () =>{
    const token = getToken()
    try{
         const response = await fetch(`${BASE_URL}/user/data`,
             {   
             method: "GET",
             
             headers: {
                 "Authorization": `Bearer ${token}`,
             }
             })
         const json_body = await response.json()
         if(json_body.status != 200 ){
             return [false, json_body.errors]
         }
         return [true , json_body.msg]     
     }catch{
         return [false,["Something Went Wrong"]]
     }
 }
const unarchivePost = async (post_id) =>{
    const token = getToken()
    try{
         const response = await fetch(`${BASE_URL}/post/unarchive`,
             {   
             method: "PUT",
             
             headers: {
                 "Authorization": `Bearer ${token}`,
                 "Content-Type": "application/json"
             },
             body: JSON.stringify({ 
                 post_id: post_id
             }), 
             })
         const json_body = await response.json()
         if(json_body.status != 200 ){
             return [false, json_body.errors]
         }
         return [true , json_body.msg]     
     }catch{
         return [false,["Something Went Wrong"]]
     }
 }

const unfollow = async (id) =>{
   const token = getToken()
   try{
        const response = await fetch(`${BASE_URL}/user/unfollow`,
            {   
            method: "POST",
            
            headers: {
                "Authorization": `Bearer ${token}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ 
                user_id: id
            }), 
            })
        const json_body = await response.json()
        if(json_body.status != 200 ){
            return [false, json_body.errors]
        }
        return [true , json_body.msg]     
    }catch{
        return [false,["Something Went Wrong"]]
    }
}

const followRequestAction = async (id,action) =>{
   const token = getToken()
   try{
        const response = await fetch(`${BASE_URL}/user/followrequest`,
            {   
            method: "POST",
            
            headers: {
                "Authorization": `Bearer ${token}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ 
                request_id: id,
                accept:action
            }), 
            })
        const json_body = await response.json()
        if(json_body.status != 200 ){
            return [false, json_body.errors]
        }
        return [true , json_body.msg]     
    }catch{
        return [false,["Something Went Wrong"]]
    }
}

const postAction = async (id,action) =>{
    const token = getToken()
    try{
         const response = await fetch(`${BASE_URL}/post/action`,
             {   
             method: "PUT",
             
             headers: {
                 "Authorization": `Bearer ${token}`,
                 "Content-Type": "application/json"
             },
             body: JSON.stringify({ 
                post_id: id,
                action:action
             }), 
             })
         const json_body = await response.json()
         if(!response.ok ){
             return [false, json_body]
         }
         return [true , json_body.msg]     
     }catch{
         return [false,["Something Went Wrong"]]
     }
 }

const aboutMe = async () =>{
    const token = getToken()
    if( !token){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/user/me`,{
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}` 
            }
        })
        if(!response.ok){
            return [false, ["Something Went Wrong"] ]
        }
        const json_body = await response.json()
        return [true , json_body]
        
    }catch{
        return [false, ["Something Went Wrong"] ]
    }
}

const search = async (query,page) =>{
    const token = getToken()
    if( !token){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/search?query=${query}&page=${page}`,{
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}` 
            }
        })
        if(!response.ok){
            return [false, ["Something Went Wrong"] ]
        }
        const json_body = await response.json()
        return [true , json_body]
        
    }catch{
        return [false, ["Something Went Wrong"] ]
    }
}

const home = async (page) =>{
    const token = getToken()
    if( !token){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/user/home?page=${page}`,{
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}` 
            }
        })
        if(!response.ok){
            return [false, ["Something Went Wrong"] ]
        }
        const json_body = await response.json()
        return [true , json_body]
        
    }catch{
        return [false, ["Something Went Wrong"] ]
    }
}

const getFollower = async () =>{
    const token = getToken()
    if( !token){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/user/followers`,{
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}` 
            }
        })
        if(!response.ok){
            return [false, ["Something Went Wrong"] ]
        }
        const json_body = await response.json()
        return [true , json_body]
        
    }catch{
        return [false, ["Something Went Wrong"] ]
    }
}

const getFollowing = async () =>{
    const token = getToken()
    if( !token){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/user/following`,{
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}` 
            }
        })
        if(!response.ok){
            return [false, ["Something Went Wrong"] ]
        }
        const json_body = await response.json()
        return [true , json_body]
        
    }catch{
        return [false, ["Something Went Wrong"] ]
    }
}

const getFollowRequest = async (status) =>{
    const token = getToken()
    if( !token){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/user/followrequests?status=${status}`,{
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}` 
            }
        })
        if(!response.ok){
            return [false, ["Something Went Wrong"] ]
        }
        const json_body = await response.json()
        return [true , json_body]
        
    }catch{
        return [false, ["Something Went Wrong"] ]
    }
}

const getPostDetail = async (post_id) =>{
    const token = getToken()
    if( !post_id){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/post/${post_id}`,{
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}` 
            }
        })
        console.log(response)
        const json_body = await response.json()
        if(!response.ok){
            return [false, json_body ]
        }
        
        return [true , json_body]
        
    }catch{
        return [false, ["Something Went Wrong"] ]
    }
}

const getPosts = async (limit,page,sortby,archive,type) =>{
    const token = getToken()
    try{
        const response = await fetch(`${BASE_URL}/post/?sortby=${sortby}&archive=${archive}&type=${type}&page=${page}&limit=${limit}`,{
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}` 
            }
        })
        console.log(response)
        const json_body = await response.json()
        if(!response.ok){
            return [false, json_body ]
        }
        
        return [true , json_body]
        
    }catch{
        return [false, ["Something Went Wrong"] ]
    }
}


const getUserDetail = async (user_id) =>{
    const token = getToken()
    if( !user_id){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/user/${user_id}`,{
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}` 
            }
        })
        console.log(response)
        const json_body = await response.json()
        if(!response.ok){
            return [false, json_body ]
        }
        
        return [true , json_body]
        
    }catch{
        return [false, ["Something Went Wrong"] ]
    }
}


const logout = async () =>{
    const token = getToken()
    if( !token){
        return false
    }
    try{
        const response = await fetch(`${BASE_URL}/user/logout`,{
            method: "DELETE",
            headers: {
                "Authorization": `Bearer ${token}` 
            }
        })
        if(!response.ok){
            return [false, ["Something Went Wrong"] ]
        }
        const json_body = await response.json()
        return [true , json_body]
        
    }catch{
        return [false, ["Something Went Wrong"] ]
    }
}

const setToken = (token) =>{
    localStorage.setItem("token", token);
}

const getToken = () =>{
    return localStorage.getItem("token")
}

export {downloadData,deleteUser,postAction,editUser,home,editPost,deletePost,unarchivePost,archivePost,unfollow,followRequestAction,followRequest, getFollowRequest,search,getFollower,getFollowing,logIn,signUp,getPosts,aboutMe,logout,createPost,getUserDetail,getPostDetail}