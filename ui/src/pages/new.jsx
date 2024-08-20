import { useRef } from "react"
import { createPost } from "../lib/api"
import { useNavigate } from "react-router-dom";
import toast from "react-hot-toast";
export default function New() {
    let navigate = useNavigate();
    const formele = useRef()
    const handleCreatePost = async (e) =>{
        e.preventDefault()
        const res = await createPost(new FormData(formele.current))
        if (res[0]){
            navigate("/home")
            return
        }
        if(Array.isArray(res[1])){
            res[1].error.forEach(error => {
                toast.error(error)
            });
            return 
        }
        toast.error(res[1].error)
    }
    return (<div className="flex flex-col  gap-[10px] items-center mx-auto">
        <h2 className="mt-[50px] font-bold text-center">Create A New Post</h2>
        <form onSubmit={handleCreatePost} ref={formele}>
        <label className="form-control w-full max-w-xs  ">

            <div className="mt-[50px]">
                <div>
                    <div className="label">
                        <span className="label-text">Caption</span>
                    </div>
                    <input name="caption" type="text" placeholder="Type here" className="input input-bordered w-full max-w-xs" />
                </div>

                <div className="mt-[10px]">
                    <div className="label">
                        <span className="label-text">Body</span>
                    </div>
                    <textarea name="body" className="w-full input-bordered  textarea textarea-ghost" ></textarea>
                </div>
            </div>
        </label>
        <label className="form-control w-full max-w-xs">
            <div className="label">
                <span className="label-text">Media</span>
            </div>
            <input name="media"  type="file" className="file-input file-input-bordered w-full max-w-xs" />
        </label>
        <div className=" flex-auto ">
            <button  type="submit" className=" rounded-md mt-[40px] btn bg-green-500">Create</button>
        </div>
        </form>
        
    </div>)

}