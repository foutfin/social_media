import {  useState } from "react"
import { editPost } from "../lib/api"


export default function EditPost(params) {
    const [caption ,setCaption] = useState(params.caption)
    const [body , setBody] = useState(params.body)
    const handleUpdate = async (post_id)=>{
        const res = await editPost(post_id,caption ,body)
        if(res[0] == true){
            // console(document.getElementById(`dialog-${post_id}`))
            document.getElementById(`dialog-${post_id}`).close()
        }
    }

    

    return (
        <div>
            <div>
                <div className="label">
                    <span className="label-text">Caption</span>
                </div>
                <input value={caption} onChange={e=>setCaption(e.target.value)} name="caption" type="text" placeholder="Type here" className="input input-bordered w-full max-w-xs" />
            </div>
            <div className="mt-[10px]">
                <div className="label">
                    <span className="label-text">Body</span>
                </div>
                <textarea value={body} onChange={e=>setBody(e.target.value)} name="body" className="w-full input-bordered  textarea textarea-ghost" ></textarea>
            </div>
            <button className="btn mt-[20px]" onClick={()=>handleUpdate(params.id)}>Update</button>

        </div>
    )
}